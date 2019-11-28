* Потанин Богдан Станиславович
* Микроэконометрика
* Семинар №2
* Классические модели бинарного выбора
********
* РАЗДЕЛ №0. Экспорт данных из РМЭЗ
********
sysuse r25i_os26с.dta
* Создадим необходимые для анализа переменные
* Факт трудоустройства
generate work = 1 if uj1 <= 4
replace work = 0 if uj1 == 5
replace work = . if uj1 >= 6
* Возраст
generate age = u_age
* Посмотрим описательные статистики переменной возраста
sum age
	* Пропуски в РМЭЗ получают значения 99999997, 99999998 и 99999999,
	* поэтому, при создании переменных от них следует избавляться.
replace age = . if age > 1000
* Образование
	* Законченное высшее
generate educ = 3 if u_diplom == 6
	* Закоченное среднее специальное
replace educ = 2 if u_diplom == 5
	* Закоченное среднее
replace educ = 1 if u_diplom == 4
	* Другое
replace educ = 0 if u_diplom < 4
replace educ = . if u_diplom > 6
	* Половая принадлежность
generate male = 1 if uh5 == 1
replace male = 0 if uh5 == 2
replace male = . if uh5 > 2
	* Количество детей
generate children = uj72_172
	* Для тех индивидов, у которых нет детей, переменная на количество детей uj72_172 принимает
	* значение, равное пропуску. Из-за этого при регрессионном анализе в случае использования данной
	* переменной из выборки будут ошибочно удалены все бездетные индивиды. Во избежание этого необходимо
	* заменить пропуски на 0 для тех индивидов, которые ответили на вопрос о наличии детей отрицательно.
replace children = 0 if (uj72_171 != .) & (children == .)
	* Создадим переменные на рост, вес и BMI
gen weight = um1
replace weight = . if um1 > 10000
gen height = um2
replace height = . if um2 > 10000
gen BMI = weight / (height / 100) ^ 2
	* Создадим переменную на брак
gen marriage = 1 if u_marst == 2
replace marriage = 0 if u_marst != 2
replace marriage = . if u_marst > 100
* Посмотрим на описательные статистики наших переменных
sum work age educ male children BMI marriage
	* Отдельно для мужчин
sum work age educ male children BMI marriage if male == 1
* Можно, также, посмотреть на гистограммы и ядерные оценки плотности
histogram age
kdensity age
	* Отдельно для женщин
histogram age if male == 0
kdensity age if male == 0
	* ЗАДАНИЯ
	* 1. По аналогии с переменной educ создайте факторную переменную на тип 
	*    населенного пункта используя переменную status.
	* 2. Создайте переменную на количество несовершеннолетних детей при помощи переменной uj72.173. При этом
	*    учтите, что те, кто ответили, что у них 0 детей, получили значение пропуск.
********
* РАЗДЕЛ №1. Линейная модель
********
* Линейная модель
	* Сначала оценим с помощью обыновенного МНК
regress work c.age c.age#c.age i.educ c.children i.marriage i.marriage#c.children c.BMI if (male == 1 & age >= 18)
	* Поскольку оценка ковариационной матрицы, полученная при помощи предыдущей команды, 
	* является смещенной, то оценить ковариационную матрицу лучше при помощи бутстрапа.
bootstrap, reps(200) seed(1): regress work c.age c.age#c.age i.educ c.children i.marriage i.marriage#c.children c.BMI if (male == 1 & age >= 18)
	* Посмотрим также на бутстрапированные 95% доверительные интервалы, так как нет гарантии того, что
	* полученные нами оценки имеют нормальное распределение.
estat bootstrap, all
	* Сохраним результаты вычислений и выборку, на которой строилась модель
 estimates store linear_model
 gen linear_model_sample = e(sample)
	* Посчитаем средний предельный эффект по каждой из переменных
margins, dydx(*)
	* Посчитаем предельные эффекты для конкретного индивида
margins, dydx(*) atmeans at(age = 30 educ = 3 children = 2 marriage = 1 BMI = 25)
	* Рассчитаем предельные эффекты для среднего индивида
margins, dydx(*) atmeans
	* Оценим точность предсказаний модели
		* Получим предсказанные значения вероятности занятости
predict work_prob_hat if linear_model_sample
		* Посмотрим на их распределение и заметим, что мы получили отрицательные
		* и превышающие единицу оценки вероятностей.
histogram work_prob_hat
sum work_prob_hat
		* Предскажем исход
generate work_hat_binary = 1 if (work_prob_hat >= 0.5) & (linear_model_sample==1)
replace work_hat_binary = 0 if (work_prob_hat < 0.5) & (linear_model_sample==1)
		* Создадим переменную на занятость для индивидов, вошедших в выборку,
		* на которой оценивались параметры модели
generate work_linear_model = 1 if (work == 1) & (linear_model_sample==1)
replace work_linear_model = 0 if (work == 0) & (linear_model_sample==1)
		* Посмотрим на долю верных предсказаний. Долю верных предсказаний, очевидно,
		* можно рассчитать как сумму диагональных элементов данной таблицы, так как по
		* строкам расположены истинные значения зависимой переменной, а по столбцам - предсказанные.
tab work work_hat_binary, cell
		* Рассчитаем наивный прогноз
	* Оценим точность предсказания
	* ЗАДАНИЯ
	* 1. Заново оцените модель, добавив в неё переменные на место проживания и куб возраста.
	*    Дайте интерпретацию полученным предельным эффектам.
	* 2. Сравните ковариационные матрицы полученные с бутстрапом и без него. Проверьте, насколько
	*    сильно они отличаются, а также сравните результаты тестов на значимость коэффициентов, полученные
	*    при помощи смещенной и бутстрапированной ковариационной матрицы, а также с использованием
	*    бутстрапированных доверительных интервалов.
	* 3. Рассчитайте предельный эффект возраста и его стандартные ошибки вручную, используя mata. Используя
	*    перцентильные бутстрапированные доверительные интервалы проверьте гипотезу о
	*    значимости предельных эффектов. Учтите, что следует рассмотреть как средний предельный
	*    эффект, так и предельный эффект для среднего индивида.
********
* РАЗДЕЛ №2. Пробит модель
********
probit work c.age c.age#c.age i.educ c.children i.marriage i.marriage#c.children c.BMI if (male == 1 & age >= 18)
* Сохраним результаты вычислений и выборку, на которой строилась модель
 estimates store probit_model
 gen probit_model_sample = e(sample)
 * Посчитаем предельные эффекты
	* Средний предельный эффект
margins, dydx(*)
	* Предельные эффекты для среднего индивида
margins, dydx(*) atmeans
	* Предельные эффекты для конкретного индивида
		* Тридцателетний индивид с двумя детьми и высшим образованием
margins, dydx(*) atmeans at(age = 30 educ = 3 children = 2 marriage = 1 BMI = 25)
		* Пятидесятилетний индивид без детей со средним образованием и несколькими средними характеристиками
margins, dydx(*) atmeans at(age = 50 educ = 1 children = 0)
* Оценим предиктивное качество модели
	* Посмотрим на число верных предсказаний
estat class, cutoff(0.5)
* Рассмотрим предсказанные вероятности
predict probit_prob, pr
sum probit_prob
histogram probit_prob
	* Предскажем вероятность того, что индивид с определенными характеристиками 
	* будет работать. Воспользуемся полученными оценками коэффициентов.
	* Для удаления ранее созданных в mata переменных используйте "mata: mata clear" без кавычек
. mata normal(-3.184311 +                  /* константа                       */
			  (30 * 0.1759575) +           /* 30 лет                          */
              (30 ^ 2 *  -0.0023452) +     /* 30 лет в квадрате               */
			  0.3094039 +                  /* среднее специальное образование */
			  3 * 0.1806816 +              /* трое детей                      */
			  0.7872511 +                  /* женатый                         */
			  (3 * 1) * -0.2843278 +       /* взаимодействие                  */
			  0.0124565 * 23)              /* индекс массы тела               */
	* Построим Рок-Кривую
lroc
* ЗАДАНИЯ
	* 1. Заново оцените модель, добавив в неё переменные на место проживания и куб возраста.
	*    Дайте интерпретацию полученным предельным эффектам.
	* 2. Рассчитайте вероятность занятости и предельный эффект возраста для индивида с вашими характеристиками.
	* 3. Рассчитайте предельный эффект возраста и его стандартные ошибки вручную, используя mata. Используя
	*    дельта метод проверьте гипотезу о значимости предельных эффектов. Учтите, что следует рассмотреть
	*    как средний предельный эффект, так и предельный эффект для среднего индивида.
********
* РАЗДЕЛ №3. Логит модель
********
logit work c.age c.age#c.age i.educ c.children i.marriage i.marriage#c.children c.BMI if (male == 1 & age >= 18)
* Сохраним результаты вычислений и выборку, на которой строилась модель
 estimates store logit_model
 gen logit_model_sample = e(sample)
 * Посчитаем предельные эффекты
	* Средний предельный эффект
margins, dydx(*)
	* Предельные эффекты для среднего индивида
margins, dydx(*) atmeans
	* Предельные эффекты для конкретного индивида
		* Тридцателетний индивид с двумя детьми и высшим образованием
margins, dydx(*) atmeans at(age = 30 educ = 3 children = 2 marriage = 1 BMI = 25)
		* Пятидесятилетний индивид без детей со средним образованием
* Оценим предиктивное качество модели
	* Посмотрим на число верных предсказаний
estat class, cutoff(0.5)
	* Построим Рок-Кривую и посмотрим на площадь под ней (AUC)
lroc
* Рассмотрим предсказанные вероятности
predict logit_prob, pr
sum logit_prob
histogram logit_prob
* Рассчитаем изменения отношения правдоподобия
logit work c.age c.age#c.age i.educ c.children i.marriage i.marriage#c.children c.BMI if (male == 1 & age >= 18), or
* Посчитаем изменение отношения шансов для возраста, так как stata выдает неправильный результат
* Это изменение будет разниться в зависимости от возраста, поэтому рассмотрим тридцатилетнего индивида
. mata exp((0.3111634 - 0.0041333 - 2 * 0.0041333 * 30))
* ЗАДАНИЯ
	* 1. Заново оцените модель, добавив в неё переменные на место проживания и куб возраста.
	*    Дайте интерпретацию полученным предельным эффектам.
	* 2. Сравните линейную, пробит и логит модели по предсказательной силе.
	* 3. Сравните пробит и логит модели по критерию AIC
	* 4. Рассчитайте вероятность занятости и предельный эффект возраста для индивида с вашими характеристиками.
	* 5. Рассчитайте предельный эффект возраста и его стандартные ошибки вручную, используя mata. Используя
	*    дельта метод проверьте гипотезу о значимости предельных эффектов. Учтите, что следует рассмотреть
	*    как средний предельный эффект, так и предельный эффект для среднего индивида.
	* 6. Рассчитайте изменение отношения шансов для возраста, добавив в модель его куб.
