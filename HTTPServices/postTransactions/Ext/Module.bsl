﻿
функция СоздатьТранзакциюДоходов(ДанныеJSON)
	Док = Документы.ТранзакцииРасходов.СоздатьДокумент();
	Док.Дата = ТекущаяДата();
	Док.ВладелецТранзакцииСумм = ДанныеJSON.userName;
	Док.Счет = Справочники.Кошелек.НайтиПоКоду(ДанныеJSON.nameAccount).Ссылка;
	Док.Тип = Справочники.ТипыДоходов.НайтиПоКоду(ДанныеJSON.type).Ссылка;
	Док.Сумма = ДанныеJSON.sum;                                               
	Док.Описание = ДанныеJSON.description;
	Док.Записать();
КонецФункции


Функция ПровестиТранзакциюДоходов(ДанныеJSON)
	НовыйСчет = Справочники.Кошелек.НайтиПоКоду(ДанныеJSON.nameAccount).Ссылка;
	НовыйТип = Справочники.ТипыДоходов.НайтиПоКоду(ДанныеJSON.type).Ссылка;
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
		СоздатьТранзакциюДоходов(ДанныеJSON);
		ПровестиТранзакциюДоходов(ДанныеJSON);
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


/////////////////////////////////////////////////////////////////////////////////////////////////////


Функция СоздатьТранзакциюРасходы(ДанныеJSON)
	Док = Документы.ТранзакцииРасходов.СоздатьДокумент();
	Док.Дата = ТекущаяДата();  
	Док.ВладелецТранзакцииВыч = ДанныеJSON.userName;
	Док.Счет = Справочники.Кошелек.НайтиПоКоду(ДанныеJSON.nameAccount).Ссылка;
	Док.Тип = Справочники.ТипыДоходов.НайтиПоКоду(ДанныеJSON.type).Ссылка;
	Док.Сумма = ДанныеJSON.sum;                                               
	Док.Описание = ДанныеJSON.description;
	Док.Записать();	
КонецФункции 


Функция ПровестиТранзакциюРасходов(ДанныеJSON)
	СтатусСоздания = 200;
	НовыйСчет = Справочники.Кошелек.НайтиПоКоду(ДанныеJSON.nameAccount).Ссылка;
	НовыйТип = Справочники.ТипыДоходов.НайтиПоКоду(ДанныеJSON.type).Ссылка;
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
