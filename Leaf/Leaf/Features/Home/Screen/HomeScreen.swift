//
//  HomeScreen.swift
//  Leaf
//
//  Created by Tsvetan Tsvetanov on 20.12.22.
//

import SwiftUI

struct HomeScreen: View {

    @ObservedObject private var viewModel: HomeScreenViewModel

    init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ScrollView {

                dataGrid
                    .frame(height: 250)
                    .padding()
            }

            Spacer()

            HStack {
                addButton
                Spacer()
                editButton
            }
            .padding()
        }
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                optionsButton
            }
        }
        .background {
            Color.gray.opacity(0.2).ignoresSafeArea(.all)
        }
    }
}

private extension HomeScreen {

    var optionsButton: some View {
        Button {
            viewModel.tapOptionsButton()
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }

    var dataGrid: some View {

        VStack(spacing: 12) {
            HStack(spacing: 12) {
                incomeCell

                expenseCell
            }

            balanceCell
        }
    }

    var incomeCell: some View {
        GridCell(
            icon: Image(systemName: "dollarsign.circle"),
            title: R.string.localizable.home_income_title(),
            ammount: "16890",
            type: .income
        )
        .background {
            Color.white
        }
        .cornerRadius(12)
    }

    var expenseCell: some View {
        GridCell(
            icon: Image(systemName: "banknote"),
            title: R.string.localizable.home_expense_title(),
            ammount: "2590",
            type: .expense
        )
        .background {
            Color.white
        }
        .cornerRadius(12)
    }

    var balanceCell: some View {
        GridCell(
            icon: Image(systemName: "creditcard"),
            title: R.string.localizable.home_balance_title(),
            ammount: "330456",
            type: .balance
        )
        .background {
            Color.white
        }
        .cornerRadius(12)
    }

    var addButton: some View {
        Button {

        } label: {
            HStack(spacing: 5) {
                Image(systemName: "plus.circle.fill")
                Text(R.string.localizable.home_add_cash_button())
            }
            .bold()
        }
    }

    var editButton: some View {
        Button(R.string.localizable.home_edit_categories_button()) {

        }
    }
}
