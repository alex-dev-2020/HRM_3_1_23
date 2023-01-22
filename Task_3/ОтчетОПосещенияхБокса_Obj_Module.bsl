
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Фиксация Движений
	Движения.Записать();
	
	
	ДанныеОВремени = ДанныеОВремени();
	УчетРабочегоВремени.ПроверитьРегистрируемыеДанныхОВремени(Ссылка, ДанныеОВремени, Отказ, Истина);
	УчетРабочегоВремени.ЗарегистрироватьРабочееВремяСотрудников(Движения, ДанныеОВремени);
	
	
	
КонецПроцедуры


Функция ДанныеОВремени()
	
	
	// Вариант № 1.  ВСЕ Виды Времени ДНЯ конкретного Дня ЗАРАНЕЕ известны 
	
	ТаблицаДанных = УчетРабочегоВремениРасширенный.ПустаяТаблицаДляРегистрацииВремени();
	
	//Для Каждого СтрокаТабличнойЧасти Из ОтчетОВремени Цикл 
	//	
	//	//Работа в Лаборатории
	//	СтрокаТаблицы = ТаблицаДанных.Добавить();
	//	СтрокаТаблицы.Дата = СтрокаТабличнойЧасти.Дата;
	//	СтрокаТаблицы.Сотрудник = СтрокаТабличнойЧасти.Сотрудник;
	//	СтрокаТаблицы.ВидВремени = ВидВремени;
	//	СтрокаТаблицы.Дней = 1;
	//	СтрокаТаблицы.Часов = (СтрокаТабличнойЧасти.ВремяВыхода - СтрокаТабличнойЧасти.ВремяВхода) / 3600;
	//	СтрокаТаблицы.Организация = Организация;
	//	
	//	
	//	// явка
	//	СтрокаТаблицы = ТаблицаДанных.Добавить();
	//	СтрокаТаблицы.Дата = СтрокаТабличнойЧасти.Дата;
	//	СтрокаТаблицы.Сотрудник = СтрокаТабличнойЧасти.Сотрудник; 
	//	// любой  из вариантов  получения предопределенного 
	//	//СтрокаТаблицы.ВидВремени = Справочники.ВидыИспользованияРабочегоВремени.Явка;
	//	СтрокаТаблицы.ВидВремени = 
	//		ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени.Явка");

	//	СтрокаТаблицы.Дней = 1;
	//	СтрокаТаблицы.Часов = 8 - (СтрокаТабличнойЧасти.ВремяВыхода - СтрокаТабличнойЧасти.ВремяВхода) / 3600;
	//	СтрокаТаблицы.Организация = Организация;
	//
	//	
	//	
	//КонецЦикла;
	//
	//Возврат ТаблицаДанных;  
	
	// Вариант № 2. Предварительно необходимо получить Рабочее Время Сотрудника 
	
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Получение ВТСотрудники   
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетОПосещенияхБоксаОтчетОВремени.Сотрудник КАК Сотрудник,
		|	НАЧАЛОПЕРИОДА(ОтчетОПосещенияхБоксаОтчетОВремени.Дата, МЕСЯЦ) КАК Месяц,
		|	КОНЕЦПЕРИОДА(ОтчетОПосещенияхБоксаОтчетОВремени.Дата, МЕСЯЦ) КАК ДатаАктуальности,
		|	МИНИМУМ(ОтчетОПосещенияхБоксаОтчетОВремени.Дата) КАК ДатаНачала,
		|	МАКСИМУМ(ОтчетОПосещенияхБоксаОтчетОВремени.Дата) КАК ДатаОкончания
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	Документ.ОтчетОПосещенияхБокса.ОтчетОВремени КАК ОтчетОПосещенияхБоксаОтчетОВремени
		|ГДЕ
		|	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ОтчетОПосещенияхБоксаОтчетОВремени.Сотрудник,
		|	НАЧАЛОПЕРИОДА(ОтчетОПосещенияхБоксаОтчетОВремени.Дата, МЕСЯЦ),
		|	КОНЕЦПЕРИОДА(ОтчетОПосещенияхБоксаОтчетОВремени.Дата, МЕСЯЦ)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Выполнить();
	

	// Получение параметров Данных Времени
	
	Параметры = УчетРабочегоВремениРасширенный.ПараметрыДляСоздатьВТДанныеУчетаРабочегоВремениСотрудников(); 
	Параметры.ИмяВТРезультат = "ВТВремя";
	
	// Получение ВТ Данных о Рабочем Времени Сотрудников
	
	УчетРабочегоВремениРасширенный.СоздатьВТДанныеУчетаРабочегоВремениСотрудников(МенеджерВременныхТаблиц, Истина , Параметры); 
	
	// получение в Запросе Таблицы Данных о Времени
	
	Запрос.Текст = 
	" ВЫБРАТЬ
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Сотрудник КАК Сотрудник,
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Дата КАК Дата,
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка.ВидВремени КАК ВидВремени,
	 |	1 КАК Дней,
	 |	РАЗНОСТЬДАТ(ОтчетОПосещенияхБоксаОтчетОВремени.ВремяВхода, ОтчетОПосещенияхБоксаОтчетОВремени.ВремяВыхода, ЧАС) КАК Часов,
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка.Организация КАК Организация
	 |ИЗ
	 |	Документ.ОтчетОПосещенияхБокса.ОтчетОВремени КАК ОтчетОПосещенияхБоксаОтчетОВремени
	 |ГДЕ
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка = &Ссылка
	 |
	 |ОБЪЕДИНИТЬ ВСЕ
	 |
	 |ВЫБРАТЬ
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Сотрудник,
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Дата,
	 |	ВТВремя.ВидУчетаВремени,
	 |	ВТВремя.Дней,
	 |	ВЫБОР
	 |		КОГДА ВТВремя.ВидУчетаВремени = ЗНАЧЕНИЕ(Справочник.ВидыИспользованияРабочегоВремени.Явка)
	 |			ТОГДА ВТВремя.Часов - РАЗНОСТЬДАТ(ОтчетОПосещенияхБоксаОтчетОВремени.ВремяВхода, ОтчетОПосещенияхБоксаОтчетОВремени.ВремяВыхода, ЧАС)
	 |		ИНАЧЕ ВТВремя.Часов
	 |	КОНЕЦ,
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка.Организация
	 |ИЗ
	 |	Документ.ОтчетОПосещенияхБокса.ОтчетОВремени КАК ОтчетОПосещенияхБоксаОтчетОВремени
	 |		ЛЕВОЕ СОЕДИНЕНИЕ ВТВремя КАК ВТВремя
	 |		ПО ОтчетОПосещенияхБоксаОтчетОВремени.Сотрудник = ВТВремя.Сотрудник
	 |			И ОтчетОПосещенияхБоксаОтчетОВремени.Дата = ВТВремя.Дата
	 |			И (ВТВремя.ВидУчетаВремени <> ЗНАЧЕНИЕ(Справочник.ВидыИспользованияРабочегоВремени.РабочееВремя))
	 |ГДЕ
	 |	ОтчетОПосещенияхБоксаОтчетОВремени.Ссылка = &Ссылка";
	
	// возврат данных о времени   
	
	Возврат Запрос.Выполнить().Выгрузить();
	
	
КонецФункции
