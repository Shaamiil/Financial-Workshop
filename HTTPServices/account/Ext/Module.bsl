﻿Функция ПолучитьВсеСчета()
	Массив = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Кошелек.Наименование КАК Наименование,
	               |	Кошелек.Сумма КАК Сумма
	               |ИЗ
	               |	Справочник.Кошелек КАК Кошелек";
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("nameAccount", Строка(ВыборкаЗапроса.Наименование));
		Данные.Вставить("sum", ВыборкаЗапроса.Сумма);
		Массив.Добавить(Данные);
	КонецЦикла;                  
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,Массив);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция allAccountGET(Запрос)
	Попытка
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.УстановитьТелоИзСтроки(ПолучитьВсеСчета());
	Исключение
		ОшибкаКода = ОписаниеОшибки();
		ЛогЗапросов = РегистрыСведений.ЛогGETЗапросов.СоздатьМенеджерЗаписи();
		ЛогЗапросов.Дата = ТекущаяДата();
		ЛогЗапросов.Запрос = Запрос.ПолучитьТелоКакСтроку();
		Если ЗначениеЗаполнено(Ответ.Заголовки) Тогда
			ЛогЗапросов.Заголовки = Ответ.Заголовки;
		Иначе
			ЛогЗапросов.Заголовки = "Заголовков нет";
		КонецЕсли;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		Если ЗначениеЗаполнено(ОшибкаКода) Тогда
			ЛогЗапросов.Ошибка = ОшибкаКода;
		Иначе	
			ЛогЗапросов.Ошибка = "Ошибок нет";
		КонецЕсли;
		ЛогЗапросов.Записать();
	КонецПопытки;
				
	Возврат Ответ;
КонецФункции

Функция ПолучитьОдинСчет(КодСсылка)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Кошелек.Наименование КАК Наименование,
	               |	Кошелек.Сумма КАК Сумма
	               |ИЗ
	               |	Справочник.Кошелек КАК Кошелек
	               |ГДЕ
	               |	Кошелек.Код = &Код";
	Запрос.УстановитьПараметр("Код",КодСсылка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("",Строка(ВыборкаЗапроса.Наименование));
		Данные.Вставить("",ВыборкаЗапроса.Сумма);
	КонецЦикла;                                   
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,Данные);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции

Функция oneAccountGET(Запрос)
	Попытка
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.УстановитьТелоИзСтроки(ПолучитьОдинСчет(Запрос.ПараметрыURL.Получить("account_code"))); 
	Исключение
		ОшибкаКода = ОписаниеОшибки();
		ЛогЗапросов = РегистрыСведений.ЛогGETЗапросов.СоздатьМенеджерЗаписи();
		ЛогЗапросов.Дата = ТекущаяДата();
		ЛогЗапросов.Запрос = Запрос.ПолучитьТелоКакСтроку();
		Если ЗначениеЗаполнено(Ответ.Заголовки) Тогда
			ЛогЗапросов.Заголовки = Ответ.Заголовки;
		Иначе
			ЛогЗапросов.Заголовки = "Заголовков нет";
		КонецЕсли;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		Если ЗначениеЗаполнено(ОшибкаКода) Тогда
			ЛогЗапросов.Ошибка = ОшибкаКода;
		Иначе	
			ЛогЗапросов.Ошибка = "Ошибок нет";
		КонецЕсли;
		ЛогЗапросов.Записать();
	КонецПопытки;
	
	Возврат Ответ;
КонецФункции

Функция СоздатьСчет(ДанныеJSON)
	Спр = Справочники.Кошелек.СоздатьЭлемент();
	Спр.Наименование = ДанныеJSON.nameAccount;
	Спр.Сумма = ДанныеJSON.sum;
	Спр.Записать();
КонецФункции

Функция oneAccountPOST(Запрос)
	Попытка
		Ответ = Новый HTTPСервисОтвет(200);
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		СоздатьСчет(ДанныеJSON);
	Исключение
		ОшибкаКода = ОписаниеОшибки();
		ЛогЗапросов = Документы.ЛогPOSTЗапросов.СоздатьДокумент();
		ЛогЗапросов.Дата = ТекущаяДата();
		ЛогЗапросов.Запрос = Запрос.ПолучитьТелоКакСтроку();
		Если ЗначениеЗаполнено(Ответ.Заголовки) Тогда
			ЛогЗапросов.Заголовки = Ответ.Заголовки;
		Иначе
			ЛогЗапросов.Заголовки = "Заголовков нет";
		КонецЕсли;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		Если ЗначениеЗаполнено(ОшибкаКода) Тогда
			ЛогЗапросов.Ошибка = ОшибкаКода;
		Иначе	
			ЛогЗапросов.Ошибка = "Ошибок нет";
		КонецЕсли;
		ЛогЗапросов.Записать();
	КонецПопытки;
	
	Возврат Ответ;
КонецФункции
