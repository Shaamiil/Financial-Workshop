﻿
функция СоздатьТранзакциюДоходов(ДанныеJSON)
	Док = Документы.ТранзакцииСумм.СоздатьДокумент();
	Док.Дата = ТекущаяДата();
	Док.Счет = Справочники.Кошелек.НайтиПоНаименованию(ДанныеJSON.nameAccount).Ссылка;
	Док.Тип = Справочники.ТипыДоходов.НайтиПоНаименованию(ДанныеJSON.type).Ссылка;
	Док.Сумма = ДанныеJSON.sum;                                               
	Док.Описание = ДанныеJSON.description;
	Док.Записать();
КонецФункции


Функция ПровестиТранзакциюДоходов(ДанныеJSON)
	НовыйСчет = Справочники.Кошелек.НайтиПоНаименованию(ДанныеJSON.nameAccount).Ссылка;
	НовыйТип = Справочники.ТипыДоходов.НайтиПоНаименованию(ДанныеJSON.type).Ссылка;
	НовыйСумма = ДанныеJSON.sum;
	
	ОбьектСчета = НовыйСчет.ПолучитьОбъект();
	ОбъектСуммы = НовыйСчет.Сумма;
	
	СуммаНовогоСчета = ОбъектСуммы + НовыйСумма;
	ОбьектСчета.Сумма = СуммаНовогоСчета;
	ОбьектСчета.Записать();
КонецФункции


Функция transactionIncomePOST(Запрос)
	Попытка
		Ответ = Новый HTTPСервисОтвет(200);
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();                
		ПровестиТранзакциюДоходов(ДанныеJSON);
		СоздатьТранзакциюДоходов(ДанныеJSON);
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


Функция СоздатьТранзакциюРасходы(ДанныеJSON)
	Док = Документы.ТранзакцииВыч.СоздатьДокумент();
	Док.Дата = ТекущаяДата();
	Док.Счет = Справочники.Кошелек.НайтиПоНаименованию(ДанныеJSON.nameAccount).Ссылка;
	Док.Тип = Справочники.ТипыДоходов.НайтиПоНаименованию(ДанныеJSON.type).Ссылка;
	Док.Сумма = ДанныеJSON.sum;                                               
	Док.Описание = ДанныеJSON.description;
	Док.Записать();	
КонецФункции 


Функция ПровестиТранзакциюРасходов(ДанныеJSON)
	СтатусСоздания = 200;
	НовыйСчет = Справочники.Кошелек.НайтиПоНаименованию(ДанныеJSON.nameAccount).Ссылка;
	НовыйТип = Справочники.ТипыДоходов.НайтиПоНаименованию(ДанныеJSON.type).Ссылка;
	НовыйСумма = ДанныеJSON.sum;
	
	ОбьектСчета = НовыйСчет.ПолучитьОбъект();
	ОбъектСуммы = НовыйСчет.Сумма;
	Если ОбъектСуммы < НовыйСумма Тогда
		СтатусСоздания = 406;
		Возврат СтатусСоздания;
	Иначе
		СуммаНовогоСчета = ОбъектСуммы - НовыйСумма;
		ОбьектСчета.Сумма = СуммаНовогоСчета;
		ОбьектСчета.Записать();
	КонецЕсли;
	
	Возврат СтатусСоздания
КонецФункции


Функция transactionExpensesPOST(Запрос)
	Попытка
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		Ответ = Новый HTTPСервисОтвет(ПровестиТранзакциюРасходов(ДанныеJSON));
		ЧтениеJSON.Закрыть(); 
		ПровестиТранзакциюРасходов(ДанныеJSON);
		СоздатьТранзакциюРасходы(ДанныеJSON);
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