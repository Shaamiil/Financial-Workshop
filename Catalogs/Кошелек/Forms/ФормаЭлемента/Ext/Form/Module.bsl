﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Объект.Дата = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Дата = ТекущаяДата();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ВладелецКошелька = ПараметрыСеанса.ИмяТекущегоПользователя;
КонецПроцедуры
