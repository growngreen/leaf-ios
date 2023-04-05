//
//  AmmountGridCell.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 5.04.23.
//

import SwiftUI

struct GridCell: View {

    enum `Type` {
        case income
        case expense
        case balance

        var color: Color {
            switch self {
            case .balance:
                return Color.black
            case .expense:
                return Color.red
            case .income:
                return Color.green
            }
        }
    }

    let icon: Image
    let title: String
    let ammount: String
    let type: `Type`

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                iconView
                Spacer()
                ammountView
            }
            .padding()

            Spacer()

            titleView
        }
    }
}

private extension GridCell {

    var iconView: some View {
        icon
    }

    var titleView: some View {
        Text(title)
            .foregroundColor(.gray)
            .font(.system(size: 18))
            .bold()
            .padding()
    }

    var ammountView: some View {
        Text(ammount)
            .font(.system(size: 24))
            .foregroundColor(type.color)
            .bold()
    }
}
