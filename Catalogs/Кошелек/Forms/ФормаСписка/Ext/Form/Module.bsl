﻿&НаКлиенте
Процедура Перевод(Команда)
	Форма = ПолучитьФорму("ОбщаяФорма.Переводы");
	Форма.Открыть();
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПолучитьСуммуСчетов();	
КонецПроцедуры 

&НаСервере
Функция ПолучитьСуммуСчетов()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(Кошелек.Сумма) КАК Сумма
	               |ИЗ
	               |	Справочник.Кошелек КАК Кошелек
	               |ГДЕ
	               |	Кошелек.ВладелецКошелька = &ВладелецКошелька";
	Запрос.УстановитьПараметр("ВладелецКошелька", ПараметрыСеанса.ИмяТекущегоПользователя);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
	    ОбщаяСумма = ВыборкаЗапроса.Сумма;
	КонецЦикла	
КонецФункции

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ПолучитьСуммуСчетов();
КонецПроцедуры
