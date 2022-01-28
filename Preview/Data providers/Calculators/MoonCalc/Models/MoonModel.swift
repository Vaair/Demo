//
//  MoonModel.swift
//  MoonCalc
//
//  Created by Emil Karimov on 02.06.2021.
//  Copyright © 2021 Emil Karimov. All rights reserved.
//

import Foundation

/// Модель лунного дня
///
/// - age: Int - лунный день
/// - sign: MoonZodiacSign - лунный знак зодиака
/// - begin: Date? - начало лунного дня
/// - finish: Date? - окончание лунного дня
public class MoonModel {

    /// лунный день
    public var age: Int

    /// лунный знак зодиака
    public var sign: MoonZodiacSign

    /// восход луны
    public var begin: Date?

    /// заход луны
    public var finish: Date?

    public init(age: Int, sign: MoonZodiacSign, begin: Date?, finish: Date?) {
        self.age = age
        self.sign = sign
        self.begin = begin
        self.finish = finish
    }
}
