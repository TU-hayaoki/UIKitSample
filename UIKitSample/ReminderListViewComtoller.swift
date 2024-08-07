//
//  ViewController.swift
//  UIKitSample
//
//  Created by Hayato Aoki on 2024/08/07.
//

import UIKit

class ReminderListViewComtoller: UICollectionViewController {
    
    //  UICollectionViewDiffableDataSource<Int, String> に対して、DataSourceと名付ける
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // viewDidLoadのタイミングでUICOllectionViewCompositionalLayoutを継承し、ListのレイアウトのConfigurationの設定の変更を行う関数の実行し、listLayout: UICOllectionViewCompositionalLayout へインスタンスを代入。
        let listLayout = listLayout()
        
        // 先ほど作成したインスタンスを、UIKit内 collectionView: UICollectionViewControllerへ代入することで、Configurationの設定値を反映。
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            
            // Model Reminder内に作成したsampleDataからデータを抽出
            let reminder = Reminder.sampleData[indexPath.item]
            var contentConfiguration = cell.defaultContentConfiguration()
            
            // contentConfiguration内のメンバーである、textへReminderクラスのインスタンス内メンバーのtitleの値を代入
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
                        return collectionView.dequeueConfiguredReusableCell(
                            using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        dataSource.apply(snapshot)
        
        collectionView.dataSource = dataSource
    }
    
    
    // ListのレイアウトのConfigurationを設定するPrivateな関数の作成
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

