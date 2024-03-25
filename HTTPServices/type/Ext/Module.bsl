﻿
Функция ПолучитьТипыДоходов(ДанныеJSON);
	Массив = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТипыДоходов.Наименование КАК Наименование,
	               |	ТипыДоходов.Код КАК Код
	               |ИЗ
	               |	Справочник.ТипыДоходов КАК ТипыДоходов
	               |ГДЕ
	               |	ТипыДоходов.ВладелецТипаДоходов = &ИмяТекущегоПользователя";
	Запрос.УстановитьПараметр("ИмяТекущегоПользователя", ДанныеJSON.userName);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаЗапроса = РезультатЗапроса.Выбрать();
	Пока ВыборкаЗапроса.Следующий() Цикл
		Данные = Новый Структура;
		Данные.Вставить("code", ВыборкаЗапроса.Код);
		Данные.Вставить("nameType", Строка(ВыборкаЗапроса.Наименование));
		Массив.Добавить(Данные);
	КонецЦикла;                  
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON,Массив);
	
	Возврат ЗаписьJSON.Закрыть();
КонецФункции


Функция incomeGET(Запрос)
	Попытка
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.УстановитьТелоИзСтроки(ПолучитьТипыДоходов(ДанныеJSON));
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
				
	Возврат Ответ
КонецФункции 


Функция expensesGET(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции


Функция СоздатьТип(ДанныеJSON)
	Спр = Справочники.ТипыДоходов.СоздатьЭлемент();
	Спр.Наименование = ДанныеJSON.nameType;
	Спр.ВладелецТипаДоходов = ДанныеJSON.userName;
	Спр.Записать();
КонецФункции


Функция incomePOSTPOST(Запрос)
	Попытка
		Ответ = Новый HTTPСервисОтвет(200);
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
		ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		СоздатьТип(ДанныеJSON);
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
