//
//  Types.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

public typealias EmptyClosure = () -> Void
public typealias TypeClosure<T> = (T) -> Void
public typealias ResultClosure<T> = (Result<T, Error>) -> Void

public typealias ToDoListDataSource = UITableViewDiffableDataSource<ToDoListSection, ToDoListItem>
public typealias ToDoListSnapshot = NSDiffableDataSourceSnapshot<ToDoListSection, ToDoListItem>
