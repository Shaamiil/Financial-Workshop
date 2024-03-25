﻿Функция ПолучитьВсеСчета(ДанныеJSON)
	Массив = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Кошелек.Код КАК Код,
	               |	Кошелек.Наименование КАК Наименование,
	               |	Кошелек.Сумма КАК Сумма
	               |ИЗ
	               |	Справочник.Кошелек КАК Кошелек
	               |ГДЕ
	               |	Кошелек.ВладелецКошелька = &ИмяТекущегоПользователя";
	Запрос.УстановитьПараметр("ИмяТекущегоПользователя",ДанныеJSON.userName);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("code", ВыборкаЗапроса.Код);
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
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.УстановитьТелоИзСтроки(ПолучитьВсеСчета(ДанныеJSON));
	Исключение
		ОшибкаКода = ОписаниеОшибки();
		ЛогЗапросов = РегистрыСведений.ЛогGETЗапросов.СоздатьМенеджерЗаписи();
		ЛогЗапросов.Дата = ТекущаяДата();
		ЛогЗапросов.Запрос = Запрос.ПолучитьТелоКакСтроку();
		ЛогЗапросов.Заголовки = Ответ.Заголовки;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		ЛогЗапросов.Ошибка = ОшибкаКода;
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
		Данные.Вставить("nameAccount",Строка(ВыборкаЗапроса.Наименование));
		Данные.Вставить("sum",ВыборкаЗапроса.Сумма);
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
		ЛогЗапросов.Заголовки = Ответ.Заголовки;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		ЛогЗапросов.Ошибка = ОшибкаКода;
		ЛогЗапросов.Записать();
	КонецПопытки;
	
	Возврат Ответ;
КонецФункции

Функция СоздатьСчет(ДанныеJSON)
	Спр = Справочники.Кошелек.СоздатьЭлемент();
	Спр.Наименование = ДанныеJSON.nameAccount;
	Спр.Дата = ТекущаяДата();
	Спр.Сумма = ДанныеJSON.sum;
	Спр.ВладелецКошелька = ДанныеJSON.userName;
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
		ЛогЗапросов.Заголовки = Ответ.Заголовки;
		ЛогЗапросов.КодСостояния = Ответ.КодСостояния;
		ЛогЗапросов.Ошибка = ОшибкаКода;
		ЛогЗапросов.Записать();
	КонецПопытки;
	
	Возврат Ответ;
КонецФункции


