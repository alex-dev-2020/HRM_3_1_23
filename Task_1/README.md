
#### Три типа Задач ЗУП

релиз ЗУП 3.1.23.20


##### Задача на Плановые Начисления

###### Постановка
- Ежемесячное Начисление  Окладу:
        - основной признак : "начисление можно  планировать" -→ это явно указано в Задании
    - Надбавка % от Оклада (всего 3 значения : 20, 30, 50)
    - Данные вводятся ежемесячно на следующий месяц текстовым файлом с разделителем `;` 
        - может быть несколько значений внутри месяца по  одному сотруднику 
- Необходимо:
    - Создать Документ для ввода данных
    - Реализовать автоматизированное начисление Надбавки
    - Заполнить График на основании данных текстового файла     

###### Реализация
- Создаваемые Объекты:
    - Документ:  собственно ввод Данных
        - Реквизиты Шапки:
          - Организация → Спр. 
          - Начисление → ПВР `Начисления` 
          - Показатель → Спр. `ПоказателиРасчетаЗарплаты`  
        - Реквизиты ТЧ:
            -  состав как  правило указан в Задании 
    - Справочник: хранение Наименований Надбавки 
    - Регистр Сведний: хранение Значений Надбавки  *→ возможно необходимо будет хранить историю изменений Значения(в дальнейшем)*
    - Подсистема  

- Проведение Документа
    - Модуль Объекта:
        - Обработку проведения пилим  по аналогии с Документом `НазначениеПлановогоНачисления`  типовой Конфы 
        - Формируем Наборы данных Пакетом Запросов:
            - `ДанныеОПлановыхНачислениях`
            - `ЗначенияПоказателей`

- Заполнение ТЧ Значениями из Текстового Файла
    - Форма Документа:
        - Создаем Реквизит:
            - Поле Выбора
            - Обработчик `Начало Выбора`
        - Создаем Команду:
            - В цикле по Строкам Документа парсим строку стандартными средствами (`СтрРазделить`)
            - **Дату в  Строку стандартными средствами !!!**
            - все Значения получаются из  соотв. Справочников - **должны быть заполнены & Идентификаторы/Коды соответствовать!**      
