//
//  LineChart2.swift
//  SinuS
//
//  Created by Loe Hendriks on 17/09/2022.
//

import SwiftUI
import Charts

/**
    Internal struct to link values and their labels.
 */
struct ChartPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Int
}

/**
    View showing the user's Sinus/Graph.
 */
struct LineChart2: View {
    private let gatherer: DataManager
    private let user: SinusUserData
    private let data: SinusData
    private static var following = false

    init(gatherer: DataManager, user: SinusUserData, data: SinusData) {
        self.gatherer = gatherer
        self.user = user
        self.data = data
    }

    var points: [ChartPoint] {
        var list = [ChartPoint]()
        print(self.data.values.count)
        if self.data.values.count > 1 {
            for val in 0...self.self.data.values.count - 1 {
                list.append(ChartPoint(label: self.data.labels[val], value: self.data.values[val]))
            }

        }

        return list
    }

    private var color: Color {
        if self.data.values.count > 1 {
            if self.data.values.last! > self.data.values[self.data.values.count - 2] {
                return Color.green
            } else if self.data.values.last! < self.data.values[self.data.values.count - 2] {
                return Color.red
            }
        }
        return Color.gray
    }

    var body: some View {
        VStack {
            Divider()

            RelationStatusView(value: self.data.values.last ?? 0)

            Divider()
            Chart {
                ForEach(points) { point in
                    LineMark(x: .value("Date", point.label.substring(from: point.label.index(point.label.endIndex, offsetBy: -4))), y: .value("Value", point.value))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 350)
            .shadow(radius: 10)
            .padding()
            .chartPlotStyle { plotArea in
                plotArea
                    .background(Style.SecondAppColor)
            }
            .foregroundColor(.white)

            Divider()

            HStack {
                SmallFrame(header: "Name:", text: self.data.sinusName)
                Spacer()

                VStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                    Divider()
                    Text(String(self.data.values.last ?? 0) + " %")
                        .font(.system(size: 10))
                        .foregroundColor(self.color)
                }

                Spacer()
                SmallFrame(header: "Target:", text: self.data.sinusTarget)
            }
            .padding()

            Divider()

            HStack {
                Button("Follow") {
                    let manager = DataManager()
                    manager.followUser(user_id: self.user.user_id)
                }
                Spacer()
                NavigationLink(destination: CompareView(initialData: data, gatherer: self.gatherer), label: {
                    Text("Compare")
                })

                Spacer()
                Button("Unfollow") {
                    let manager = DataManager()
                    manager.unFollowUser(user_id: self.user.user_id)
                }

            }
            .foregroundColor(Style.AppColor)
            .padding()

        }
        .toolbar(.visible, for: ToolbarPlacement.navigationBar)
        .toolbarBackground(Style.AppColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct LineChart2_Previews: PreviewProvider {
    static var previews: some View {
        LineChart2(
            gatherer: DataManager(),
            user: SinusUserData(
            id: 1,
            name: "Lukas",
            user_id: 1,
            date_name: "Target",
            created_at: "",
            updated_at: "",
            deleted_at: "",
            archived: 0),
            data: SinusData(
                id: 1,
                values: [ 20, 30],
                labels: [ "label", "Lavel" ],
                sinusName: "Name",
                sinusTarget: "Name"))
    }
}
