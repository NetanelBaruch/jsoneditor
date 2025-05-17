import WidgetKit
import SwiftUI

struct RateResponse: Decodable {
    let rates: [String: Double]
}

struct EuroILSEntry: TimelineEntry {
    let date: Date
    let rate: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> EuroILSEntry {
        EuroILSEntry(date: Date(), rate: 3.97)
    }

    func getSnapshot(in context: Context, completion: @escaping (EuroILSEntry) -> ()) {
        fetchRate { rate in
            let entry = EuroILSEntry(date: Date(), rate: rate)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EuroILSEntry>) -> ()) {
        fetchRate { rate in
            let entry = EuroILSEntry(date: Date(), rate: rate)
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func fetchRate(completion: @escaping (Double) -> Void) {
        let url = URL(string: "https://api.exchangerate.host/latest?base=EUR&symbols=ILS")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            var rate: Double = 3.97
            if let data = data,
               let decoded = try? JSONDecoder().decode(RateResponse.self, from: data),
               let value = decoded.rates["ILS"] {
                rate = value
            }
            completion(rate)
        }.resume()
    }
}

struct EuroILSWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("EUR → ILS")
                .font(.headline)
            Text("1 € = \(String(format: \"%.2f\", entry.rate)) ₪")
                .font(.title2)
        }
        .padding()
    }
}

@main
struct EuroILSWidget: Widget {
    let kind: String = "EuroILSWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EuroILSWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Euro to ILS Rate")
        .description("Shows the current Euro to ILS rate.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
