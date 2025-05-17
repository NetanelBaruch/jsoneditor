import SwiftUI

struct RateResponse: Decodable {
    let rates: [String: Double]
}

struct ContentView: View {
    @State private var rate: Double?

    var body: some View {
        VStack {
            if let rate = rate {
                Text("1 EURO = \(String(format: \"%.2f\", rate)) ILS")
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .task {
            await fetchRate()
        }
    }

    private func fetchRate() async {
        let url = URL(string: "https://api.exchangerate.host/latest?base=EUR&symbols=ILS")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(RateResponse.self, from: data),
               let value = decoded.rates["ILS"] {
                rate = value
            }
        } catch {
            rate = 3.97
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
