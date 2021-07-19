//
//  ApiError.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/15.
//

import Foundation

enum ApiError : Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}
