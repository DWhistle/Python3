# Потанин Богдан Станиславович
# Микроэконометрика
# Семинар №2 - Классические модели бинарного выбора
#--------------
# РАЗДЕЛ №0. Подготовка данных
#--------------
# Подключение библиотек
# Важно: если у вас нет какой-то из этих блиблиотек, то
# её следует установить
packages <- c("foreign", "ggplot2", "BaylorEdPsych", "miscTools", "pROC", "margins", "boot", "lmtest", "numDeriv")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) 
{
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
library("foreign")             # импорт данных
library("ggplot2")             # красивые графики
library("BaylorEdPsych")       # PseudoR2
library("miscTools")           # Медианные значния по столбцам
library("pROC")                # ROC кривая
library("margins")             # Предельные эффекты
library("boot")                # бутстрап
library("lmtest")              # дополнительные функции для тестирования гипотез
library("numDeriv")
# Отключим scientific notation
options(scipen = 999)            
# Загрузка данных
new_data <- read.spss("E:\\Преподавание\\Микроэконометрика\\R\\Семинар 2\\r25i_os_31.sav",   # путь к файлу (замените на свой)
            to.data.frame = TRUE,                                                            # загружаем как dataframe
            use.value.labels = TRUE,                                                         # использовать численные значения 
                                                                                             # вместо слов для некоторых переменных
                                                                                             
            max.value.labels = 30)                                                           # сколько различных значений должна принимать
                                                                                             # переменная, чтобы считаться численной, а не факторной
# Инициализируем некоторые вспомонательные фукции для обработки данных
# Добавление NA в непрерывные переменные
missing_to_NA <- function(my_variable,             # обрабатываемая переменная
                          to_numeric = FALSE)      # нужно ли перевести факторную переменную в численную
{
  if (is.numeric(my_variable)) #если мы имеем дело с количественной переменной
  {
    # В РМЭЗ отсутствие ответа на вопрос закодировано числами от 99999996 до
    # 99999999, поэтому перед началом анализа следует присвоить соответствующим
    # значениям пропуски
    my_variable[(my_variable == 99999996) | (my_variable == 99999997) | 
                  (my_variable == 99999998) |(my_variable == 99999999)] <- NA
  } else                       #если мы столкнулись с факторной (категориальной) переменной
  {
    # Для факторных переменных при чтении данных из SAV. файла сохраняются строковые значения,
    # некоторые из которых необходимо вручную заменить на пропуски
    my_variable[(my_variable == "ЗАТРУДНЯЮСЬ ОТВЕТИТЬ") | 
                  (my_variable =="ОТКАЗ ОТ ОТВЕТА") | 
                  (my_variable == "НЕТ ОТВЕТА")] <- NA
    my_variable=droplevels(my_variable)
  }
  if (to_numeric) #если нужно перевести фактоорную переменную в ччисленную
  {
    if (is.factor(my_variable))
    {
      my_variable <- as.character(my_variable)
    }
    my_variable <- as.numeric(my_variable)
  }
  return(my_variable)
}
# Присваиваем некоторое значение вместо пропуска при соблюдении условия
NA_to_value<-function(my_variable, condition, value)
{
  my_variable[condition] <- value;
  return(my_variable)
}
# Перекодирование категориальных переменных в бинарные
factor_to_binary<-function(my_variable,factor_name)
{
  new_variable=rep(x = NA, times = length(my_variable)) # создаем переменную состояющую из пропусков 
  new_variable[!is.na(my_variable)                      # заменяем на 0 все значения, не соответствующие пропуску
               & my_variable != "ЗАТРУДНЯЮСЬ ОТВЕТИТЬ"
               & my_variable != "ОТКАЗ ОТ ОТВЕТА"
               & my_variable != "НЕТ ОТВЕТА"] <- 0          
  new_variable[my_variable == factor_name] <- 1         # присваиваем значение 1 при определенных значениях
                                                        # факторной переменной
  #с нужным значением фактора
  return(new_variable)
}
# перекодируем факторную переменную в количесивенную
factor_to_numeric <- function(x)
{
  return(as.numeric(levels(x))[x])
}
# Создадим переменные
# Создадим отдельную переменную для хранения обработанных данных
# и сразу вместе с ней переменную на возраст
# Пропуски в РМЭЗ получают значения 99999997, 99999998 и 99999999,
# поэтому, при создании переменных от них следует избавляться, что можно
# осуществить при помощи функции missing_to_NA
summary(new_data$u_age)
h <- data.frame('age' = missing_to_NA(new_data$u_age))
# Переменная - работает индивид или нет
summary(new_data$uj77)
h$work <- factor_to_binary(new_data$uj77,
                        "РЕСПОНДЕНТ СЕЙЧАС РАБОТАЕТ, НАХ-СЯ В ОПЛАЧИВ. ИЛИ НЕОПЛАЧ.ОТПУСКЕ, В Т.Ч. ДЕКРЕТНОМ ИЛИ ПО УХОДУ ЗА РЕБЕНКОМ ДО 3 ЛЕТ")
# Переменная - образование
summary(new_data$u_diplom)
h$educ_1 <- factor_to_binary(new_data$u_diplom, "законченное среднее образование")
h$educ_2 <- factor_to_binary(new_data$u_diplom, "законченное среднее специальное образование")
h$educ_3 <- factor_to_binary(new_data$u_diplom, "законченное высшее образование и выше")
# Переменная - наличие детей
summary(new_data$uj72.171)
h$children <- factor_to_binary(new_data$uj72.171, "Да")
# Переменная - количество детей
h$children_n <- factor_to_numeric(missing_to_NA(new_data$uj72.172))
h$children_n[h$children == 0] <- 0
# Переменная - количество несовершеннолетних детей
h$children_n_18 <- factor_to_numeric(missing_to_NA(new_data$uj72.173))
h$children_n_18[new_data$uj72.173 == "НЕТ ДЕТЕЙ МОЛОЖЕ 18"] <- 0
h$children_n_18[h$children_n == 0] <- 0
# Переменная - пол
h$male <- 0
h$male[new_data$uh5=="МУЖСКОЙ"] <- 1
# Переменные - вес, рост и BMI (индекс массы тела)
h$weight <- missing_to_NA(new_data$um1)
h$height <- missing_to_NA(new_data$um2)
h$BMI <- h$weight / (h$height / 100) ^ 2
#Переменная - состоит в оффициальном браке
h$marriage <- factor_to_binary(missing_to_NA(new_data$u_marst),"Состоите в зарегистрированном браке")
#--------------
#РАЗДЕЛ №1. Линейная вероятностная модель
#--------------
# Регрессия на занятость
  # Для начала сделаем подвыборку
selection_condition <- (h$male == 1 & h$age >= 18)   # построим модель для совершеннолетних мужчин
  # Оценим модель
model_linear <- lm(work ~ age + I(age ^ 2) +         # записываем формулу
                   educ_1 + educ_2 + educ_3 +
                   children_n_18 + marriage + I(marriage * children_n_18) +
                   BMI, 
                   data = h[selection_condition,])   # выбираем данные
  # Посмотрим на результаты оценивания
summary(model_linear)                                #красивая репрезентация результатов оценивания модели
  # Достанем коэффициенты модели
model_coef <- coef(model_linear)
# Поскольку оценка ковариационной матрицы, полученная при помощи предыдущей команды, 
# является смещенной, то оценить ковариационную матрицу лучше при помощи бутстрапа.
lm_boot <- function(formula,   # используемая для построения модели формула
                   data,       # данные
                   indices)    # вспомогательный аргумент для функции boot
{
  d <- data[indices,]              # функция boot подает на вход индексы на основании которых формируется новая выборка 
                                   # из старой с возвращением
  model <- lm(formula, data = d)   # по новой выборке оценивается модель
  return(coefficients(model))      # возвращаем вектор реализаций МНК оценок регрессионных коэффициентов
}
model_linear_boot <- boot(data = h[selection_condition,],      # исходная выборка (аргумент функции lm_boot)
                          R = 200,                             # количество итераций
                          statistic = lm_boot,                 # функция, возвращающая значения МНК оценок
                          formula = formula(model_linear))     # аргмент функции lm_boot, определяющий функциональную форму модели
# Посмотрим на полученные значения, где
# ti* (по строкам) - строка относится к i-му регрессионному коэффициенту. Например, строка t1* относится к константе,
# а строка t2* - к переменной на возраст. Переменные идут в том же порядке, в котором они были записаны в формуле.
# ogirinal - значение реализации оценки, полученное по исходной выборке
# bias - разница между значением реализации оценки, полученным по исходной выборке и средним значением оценок данного
# параметра, полученным по результатам процедуры бутстрапирования
# std. error - реализации бутстрапированной оценки стандартной ошибки оценки регрессионного коэффициента.
model_linear_boot
# можем получить оценку ковариационной матрицы и вручную пользуясь тем, что
# свойство $t по строкам содержит оценки регрессионных коэффициентов с i-й итерации
colnames(model_linear_boot$t) <- names(coefficients(model_linear))
model_linear_cov <- cov(model_linear_boot$t)
  # сравним старые и новые стандартные ошибки
data.frame("Бутстрапированные стандартные ошибки" = sqrt(diag(model_linear_cov)),
           "Старые стандартные ошибки"            = sqrt(diag(vcov(model_linear))))
  # используем новую реализацию оценки ковариационной матрицы оценок регрессионных коэффициентов 
  # для тестирования гипотез о регрессионных коэффициентах сохраняя допущение о нормальности, в случае
  # нарушения которого полученные выводы могут оказаться ложными (так как неверно будут посчитаны p-value)
coeftest(model_linear, vcov. = model_linear_cov)
  # протестируем гипотезы при помощи перцентильных бутстрапированных интервалов, опуская
  # допущение о нормальности
boot.ci(model_linear_boot,            # объект, содержащий результаты бутстрапирования
        type="perc",                  # указываем, что хотим получить перцентильный бутстрапированный интервал для оценок
        conf = c(0.9, 0.95, 0.99),    # указываем, каких уровней бутстрапированные доверительные интервалы нам нужны
        index = 1)                    # какого из коэффицеинтов доверительный интервал нам интересен (в данном случае для константы)
                                      # а заменив на 2 получим для возраста и т.д.
# Рассмотрим предсказанные вероятности
probability_predicted <- predict(model_linear)                                                   # при помощи встроенной функции
probability_predicted <- as.matrix(model_linear$model[-1]) %*% model_coef[-1] + model_coef[1]    # при помощи линейной алгебры
summary(probability_predicted)                                                                   # есть значения больше 1 и меньше 0
hist(probability_predicted)                                                                      # гистограмма реализаций оценок предельных эффектов
  # Графически также легко увидеть вероятности больше 1 и меньше 0
ggplot(data=as.data.frame(probability_predicted), 
       aes(x=1:length(probability_predicted), y=sort(probability_predicted), group = 1)) +
       geom_point(color = "coral3", size = 1.5) + scale_y_continuous(breaks = seq(0, 1, 0.1)) +
       theme_classic() +
       geom_hline(yintercept = 0, color = "coral4", size = 2, linetype="dashed") +
       geom_hline(yintercept = 1, color = "coral4", size = 2, linetype="dashed") +
       xlab("Номер наблюдения") +
       ylab("Предсказанная вероятность занятости")
  # Предсказанные значения (1 - работает, 0 - не работает)
work_predict <- as.numeric(probability_predicted >= 0.5)                             # бинарные предсказания
  # таблица с долями истинных и предсказанных значений
  prediction_table <- table(
        "Истинные значения"=model_linear$model$work,
        "Предсказанные значения" = work_predict) /                                  # таблица с долями истинных и 
        length(work_predict)                                                        # предсказанных значений
right_predictions <- prediction_table[1,1] + prediction_table[2,2]                  # доля верных предсказаний
data.frame("Модель линейных вероятностей"=right_predictions,
     "Наивный прогноз"=
     max(sum(model_linear$model$work),1 - sum(model_linear$model$work)) /   # соотношение верных предсказаний и
    length(model_linear$model$work),                                        # общего числа работающих (наивный прогноз)
    row.names = "Доля правильных предсказаний")                             
  # Реализации оценок случайных ошибок
errors_estimates <- model_linear$model$work-probability_predicted          # случайные ошибки зависят от коэффициентов и
                                                                           # независимых переменных,
                                                                           # поэтому оценки ошибок зависят от независимых
                                                                           # переменных и от оценок коэффициентов
errors_binary_variance_estimates <- probability_predicted *
                                 (1 - probability_predicted)
summary(errors_binary_variance_estimates)                                  # беда - реализации оценок дисперсии ошибок бывают отрицательными
ggplot(data=data.frame(probability_predicted,
                       errors_binary_variance_estimates),
       aes(y=errors_binary_variance_estimates,x=probability_predicted)) +
       geom_point(col="coral3", size = 2) +
       labs(x = "Оценка вероятности занятости",
       y="Оценка дисперсии случайной ошибки") +
       geom_hline(yintercept = 0, color = "coral1", size = 0.5,
       linetype = "dashed") +
       theme_classic()  
# Предельные эффекты (легко интерпретируются)
# Важно: вероятность изменяется в абсолютных значениях от 0 до 1,
# а не в процентных пунктах, процентах и т.д.
model_linear_frame <- model_linear$model                 # матрица использовавшихся в регрессии переменных
model_linear_coef <- coef(model_linear)                  # реализации оценок коэффициентов
  # Для переменной BMI
me_BMI <- model_linear_coef["BMI"]
   #Для переменной возраст
me_age <- model_linear_coef["age"] + 2 *                                      
       model_linear_coef["I(age^2)"] * model_linear_frame$age;  # предельный эффект возраста
total_effect_age_max <- -1 * (model_linear_coef["age"]) /       # максимизирующий эффект возраста на занятость возраст
  (2 * model_linear_coef["I(age^2)"]);
ggplot(data=data.frame("age"=model_linear_frame$age,            # визуализация предельных эффектов
            "me_age"=me_age),aes(y=me_age,x=age))+
  geom_line(col="darkcyan", size=2)+
  labs(x = "Возраст", 
       y="Предельный эффект возраста")+
  geom_hline(yintercept=0, color="cornflowerblue", size=0.5, 
             linetype="dashed")+
  geom_vline(xintercept=total_effect_age_max, color="cornflowerblue", size=0.5, 
                                           linetype="dashed")+
  theme_classic()+
  annotate("text", x = total_effect_age_max+5, y = 0.005, 
           label = paste("Максимизирующий вероятность\nзанятости возраст ",
                         round(total_effect_age_max,2),"\n(на пересечении)"), size=5)+
  annotate("text", x = 30, y = 0.02, 
           label = "Положительный предельный эффект возраста", size=5)+
  annotate("text", x = 50, y = -0.02, 
           label = "Отрицательный предельный эффект возраста", size=5)+
  annotate("segment", x = total_effect_age_max+2, xend = total_effect_age_max+0.1, 
           y = 0.0035, yend = 0.0005, colour = "cornflowerblue", size=3, alpha=0.85, 
           arrow=arrow(angle = 30,type = "open"))
  # Реализация оценки предельного эффекта высшего образования
me_educ_3_0 <- model_linear_coef["educ_3"]                                 #по сравнению с отсутствием хотя бы среднего образования
me_educ_3_1 <- model_linear_coef["educ_3"] - model_linear_coef["educ_1"]   #по сравнению со средним образованием
me_educ_3_2 <- model_linear_coef["educ_3"] - model_linear_coef["educ_2"]   #по сравнению со средним специальным образованием
data.frame("По сравнению со средним образованием" = me_educ_3_1,
           "По сравнению со средним специальным образованием" = me_educ_3_2, 
           row.names = "Предельный эффект высшего образования")
  # Реализация оценки предельного эффекта количества несовершеннолетних детей
me_children_n_18_marriage <- model_linear_coef["children_n_18"] +       #не забываем учитывать эффект взаимодействия
  model_linear_coef["I(marriage * children_n_18)"] *                    #Y=B1*Дети+B2*Брак+B3*(Дети*Брак)=B2*Брак+(B1+B3*Брак)*Дети
  model_linear_frame$marriage;                                          #Откуда dY/dДети=(B1+B3*Брак)
data.frame("Для замужних"=me_children_n_18_marriage[model_linear_frame$marriage==1][1],
           "Для холостых"=me_children_n_18_marriage[model_linear_frame$marriage==0][1], 
           row.names = "Предельный эффект числа несовершеннолетних детей")
  # Используя реализации оценок рассчитаем вероятность занятости для индивида с конкретными характеристиками
    # Воспользуемся встроенной функцией
individual <- data.frame("age" = 30,                            # характеристики индивида
                         "educ_1" = 0, "educ_2" = 1, 
                         "educ_3" = 0, "children_n_18" = 2,
                         "marriage" = 1,
                         "BMI" = 28)
predict(model_linear,                                           # модель, по которой осуществляется предсказание
        newdata = individual)                                   # характеристики индивида
    # Осуществим расчет вручную
individual <- data.frame("Intercept" = 1,                       # записываем характеристики в том же порядке,
                          "age" = 30, "I(age^2)" = 30 ^ 2,      # в котором идут коэффициенты модели
                         "educ_1" = 0, "educ_2" = 1, 
                         "educ_3" = 0, "children_n_18" = 2,
                         "marriage" = 1,
                         "I(marriage * children_n_18" = 1 * 2,
                         "BMI" = 28)
sum(individual * model_linear_coef)                             # получаем такую же вероятностЬ, как и с помощью встроенной функции
  # ЗАДАНИЯ
  # 1. Постройте линейно-вероятностную модель на посещение фейсбука (переменная uj401.3a),
  #    используя независимые переменные на возраст, пол и образование, а также учитывая эффект взаимодействия 
  #    межу возрастом и полом (добавьте переменную пол * возраст). При тестировании гипотез пользуйтесь бутстрапированными
  #    доверительными интервалами (лучше всего перцентильными).
  # 2. Используя реализации оценок линейно-вероятностной модели рассчитайте вероятность, с
  #    которой вы посещаете социальную сеть фейсбук (считайте, что у вас уже есть высшее образование)
  # 3. Посчитайте долю реализаций оценок вероятностей, меньше 0 или больше 1
  # 4. Сравните результаты прогнозов по вашей модели с навивным прогнозом
  # 5. Перечислите основные теоретические проблемы, связанные с линейно-вероятностной моделью
  # 6. Рассчитайте реализации оценок предельных эффектов для всех переменных
  # 7. Включите в модель куб возраста, постройте график его предельного эффекта, дайте интерпретацию,
  #    найдите возраст, при котором, при прочих равных, вероятность использования фейсбука будет максимальной
  # 8. При помощи бутстрапа найдите бутстрапированные стандартные ошибки и ковариационную матрицу сначала для средних предельных эффектов,
  #    а затем для предельных эффектов для среднего индивида. При помощи 95% бутстрапированных доверительных интервалов проверьте гипотезы
  #    о равенстве соответствующих предельных эффектов нулю.
#--------------
#РАЗДЕЛ №2. Пробит модель
#--------------
# Построение моделей
model_probit <- glm(work ~ age + I(age ^ 2) +         
                           educ_1 + educ_2 + educ_3 +
                           children_n_18 + marriage + I(marriage * children_n_18) +
                           BMI,
                  data=h[selection_condition,], 
                  family = binomial(link="probit"))
  # Отличие в синтаксие от линейной регресси заключается в том, что используется
  # функция lm вместо glm, а также в указании типа распределения family=binomial(link="probit")
summary(model_probit)
# Запись коэффициентов и фрейма модели
model_probit_frame <- model_probit$model # записываем в отдельный dataframe наблюдения,
                                         # по которым была оценена модель (то есть зависимую и независимую переменные)
model_probit_coef <- coef(model_probit)  # записываем значения оценок коэффициентов модели
# Предсказание
  # Предсказанные значения латентной переменной
latent_values <- predict(model_probit)   # оценки латентной переменной, то есть xb
summary(latent_values)                   # посмотрим на описательные статистики оценок латентной переменной
  # Вероятности
probability_predicted <- pnorm(latent_values)   # вероятность оценивается как функция стандартного нормального
                                                # распределения pnorm в точке оценки латентной переменной
  # Предсказанные значения
work_predict <- (probability_predicted >= 0.5)  # индиви работает, если его вероятность занятости больше 0.5, что,
                                                # учитывая введенные допущения о распределении случайной ошибки, эквивалетно
                                                # тому, что латентная переменная больше 0
summary(work_predict)                        
  # Верные прогнозы
correct_predictions <- (work_predict == model_probit_frame$work)                       # количество верных прогнозов
correct_predictions_share <- sum(correct_predictions) / length(correct_predictions)    # доля верных прогнозов
data.frame("Модель линейных вероятностей" = right_predictions,
           "Пробит модель" = correct_predictions_share,
           "Наивный прогноз" =
            max(sum(model_linear$model$work), 1 - sum(model_linear$model$work)) /      # соотношение верных предсказаний и
            length(model_linear$model$work),                                           # общего числа работающих (наивный прогноз)
            row.names = "Доля правильных предсказаний")                                       
  # ROC-кривая
  # sensitivity (true positive rate) - доля занятых, верно классифицированных занятыми
  # specificities (true negative rate) - доля незанятых, верно классифицированных незанятыми
rocCurve <- roc(work ~ predict(model_probit,type=c("response")), data = model_probit_frame) # Создаем ROC кривую
plot(rocCurve)                                                                              # Стандартный график
plot(y=rocCurve$sensitivities, x=rocCurve$specificities, xlim = c(1, 0),                    # Ручной график
     xlab = "Специфичность", ylab="Чувствительность")
AUC_probit <- rocCurve$auc                                                                  # AUC
  # Сраним рок кривые для пробит и линейно-вероятностной моделей
rocCurve_linear <- roc(work ~ predict(model_linear,type=c("response")), data = model_linear_frame)
plot(y=rocCurve$sensitivities, x = rocCurve$specificities, xlim = c(1, 0),                   
     xlab = "Специфичность", ylab="Чувствительность", col = "red", type = "line",
     main = "Зеленый - пробит, Красный - линейно-вероятностная модель")
lines(y=rocCurve_linear$sensitivities, x = rocCurve_linear$specificities, col = "green")
  # Допустим, что мы хотим получить модель с уровнем sensitivity не ниже определенного. Тогда мы выбираем ту модель,
  # которая при данном уровне sensitivity обеспечит наибольшой уровень specificities. С графической точки зрения на каждом из
  # промежутков мы выбираем ту модель, у которой график на ROC кривой лежит выше.
  # ЗАДАНИЯ
    #1. Сделайте красивый график ROC кривой при помощи ggplot2
    #2. Напишите функцию, которая будет вручную рассчитывать значения specificities и sensitivity
    #   для вашей модели. ROC кривая строится за счет того, что вы присваиваете различные пороговые
    #   значения вероятности, при которой вы будете назначать значение 1 для рассматриваемого признака.
    #3. Напишите функцию, которая будет, по заданным значениям sensetivity и specificity,
    #   рассчитывать AUC
# Предельные эффекты
  # Обратим внимание, что в самом простом случае me_k=dY/dx_i=dF(xb)/dx_k=b_k*f(xb)
me_BMI_probit <- model_probit_coef["BMI"] * dnorm(latent_values)
hist(me_BMI_probit)                                                                        # видим, что теперь предельный
                                                                                           # BMI для всех индивидов разный
data.frame("Модель линейных вероятностей" = me_BMI,"Пробит модель" = mean(me_BMI_probit),  # средние значения похожи
           row.names = "Предельный эффект BMI на вероятность занятости")
  # Однако если наша переменная (x_k) входит не линейно, а как некоторая функция g(x_k), то
  # предельный эффект принимает вид me_i=dY/dx_k=dF(xb)/dx_k=(dg(x_k)/dx_k)*f(xb)
  # Для переменной age
me_age_probit <- (model_probit_coef["age"] + 2 * model_probit_coef["I(age^2)"] *
                  model_probit_frame$age) * dnorm(latent_values)
hist(me_age_probit)                                                                           # распределение реализаций оценок предельного
                                                                                              # эффекта возраста среди индивидов
data.frame("Модель линейных вероятностей"=mean(me_age),"Пробит модель"=mean(me_age_probit),   # средние значения 
           row.names = "Предельный эффект возраста на вероятность занятости")                 # вновь похожи
  # Для высшего образования
latent_values_educ_1 <- latent_values - model_probit_frame$educ_1 * model_probit_coef["educ_1"] -    # присваиваем всем 
                                        model_probit_frame$educ_2 * model_probit_coef["educ_2"] -    # отсутствие образования
                                        model_probit_frame$educ_3 * model_probit_coef["educ_3"]      
me_educ_3_0_probit <- pnorm(latent_values_educ_1 + model_probit_coef["educ_3"]) -
                      pnorm(latent_values_educ_1)
me_educ_3_1_probit <- pnorm(latent_values_educ_1 + model_probit_coef["educ_3"]) -
                      pnorm(latent_values_educ_1 + model_probit_coef["educ_1"])
me_educ_3_2_probit <- pnorm(latent_values_educ_1 + model_probit_coef["educ_3"]) -
                      pnorm(latent_values_educ_1 + model_probit_coef["educ_2"])
data.frame("Модель линейных вероятностей"=mean(me_educ_3_1),"Пробит модель"=mean(me_educ_3_1_probit),   # средние значения 
           row.names = "P(Занятость|X,Высшее)-P(Занятость|X,Среднее)")                                  # как всегда похожи
data.frame("Модель линейных вероятностей"=mean(me_educ_3_2),"Пробит модель"=mean(me_educ_3_2_probit),    
           row.names = "P(Занятость|X,Высшее)-P(Занятость|X,Среднее специальное)")
# Предельный эффект для среднего индивида
mean_individual <- as.data.frame(matrix(NA, ncol = ncol(model_probit_frame), nrow = 1))  # переменная для хранения характеристик
                                                                                         # среднего индивида
names(mean_individual) <- names(model_probit_coef)                                       # для удобства присвоим характеристикам имена
  # Значения бинарных переменных стоит подобрать вручную, исходя из
  # того, что чаще встречается
  # Сделаем для этого специальную функцию
most_frequent <- function(individual,some_dataframe,names_variables)
{
  frequencies <- colMeans(model_probit_frame[,names_variables]);   # считаем частоты для каждой из категории
  individual[names_variables] <- 0;                                # присваиваем всем категориям значение 0
  individual[names_variables][frequencies==max(frequencies)] <- 1; # присваиваем значение 1 наиболее часто 
                                                                   # встречающейся категории
  return(individual)                                               # возвращаем индивида со значением 1 только
                                                                   # для наиболее часто встречающейся категории
}
  # Добавим среднему индивиду единичный вектор с целью учета константы
mean_individual["(Intercept)"] <- 1
  # Воспользуемся созданной ранее функцией
mean_individual <- most_frequent(mean_individual,model_probit_frame,c("educ_1", "educ_2", "educ_3"))
  # Посмотрим, кого больше, женатых или холостыхи и отнесем индивида к той группе, которая больше
summary(as.factor(model_probit_frame$marriage))
mean_individual["marriage"] <- 1
  # Для количества детей поступим по аналогии
summary(as.factor(model_probit_frame$children_n_18))
mean_individual["children_n_18"] <- 0
  # Переменную на BMI для среднего индивида рассчитаем просто как среднее
mean_individual["BMI"] <- mean(model_probit_frame$BMI)
  # Учтем, что квадрат возраста среднего индивида это не средний квадрат возраста по выборке, а квадрат среднего возраста
mean_individual["age"] <- mean(model_probit_frame$age)
mean_individual["I(age^2)"] <- mean_individual["age"]^2
  # По аналогии учтем значение переменной взаимодействия для среднего индивида
mean_individual["I(marriage * children_n_18)"] <- mean_individual["children_n_18"] * mean_individual["marriage"]
  # Полюбуемся на нашего индивида
mean_individual
  # Рассчитаем реализацию оценки латентной переменной для среднего индивида
mean_individual_latent <- sum(mean_individual * model_probit_coef)
  # Посмотрим на реализацию предельного эффекта возраста для среднего индивида
me_age_probit_at_mean <- (model_probit_coef["age"] + 2 * model_probit_coef["I(age^2)"] *
                         mean_individual["age"]) * dnorm(mean_individual_latent)
data.frame("Предельный эффект для среднего индивида" = as.numeric(me_age_probit_at_mean),            
           "Средний предельный эффект" = mean(me_age_probit),    
           row.names = "Предельный эффект возраста на вероятность занятости")
  # Предельные эффекты можно также посчитать, используя встроенные функции
  # Однако для расчета предельных эффектов в данном случае переменные взаимодействия
  # следует задавать через двоеточие
model_probit <- glm(work ~ age + I(age ^ 2) +         
                           educ_1 + educ_2 + educ_3 +
                           children_n_18 + marriage + marriage:children_n_18 +
                           BMI,
                  data = h[selection_condition,], 
                  family = binomial(link="probit"))
  # Поставьте unit_ses = FALSE, если вам не нужны стандартные ошибки
  # При unit_ses = TRUE считать будет очень долго, можно сходить попить чай
me <- margins(model = model_probit, 
              variables = "age",                                            # уберите эту строку, чтобы посчитать реализации оценок
                                                                            # предельных эффектов сразу для всех переменных
              unit_ses = TRUE)
summary(me)                                                                 # обратите внимание, что summary содержит 
                                                                            # тест на значимость среднего предельного эффекта
  # Посмотрим на распределение предельных эффектов образования
me_age <- me$dydx_age
hist(me_age)
   # Убедимся, что наш результат совпадает с полученными при помощи встроенной функции
cbind(me_age_probit, me_age)
   # Построим 90% доверительный интервал для предельного эффекта возраста
   # Функция qnorm возвращает квантиль нормального распределенияя
me_age_std <- me$SE_dydx_age                                                   # стандартные ошибки предельных эффектов возраста
me_age_confidence_left <- qnorm(0.05, mean=me_age, sd = me_age_std)            # левая граница доверительного интервала
me_age_confidence_right <- qnorm(0.95, mean=me_age, sd = me_age_std)           # правая граница доверительного интервала
summary(0 > me_age_confidence_left & 0 < me_age_confidence_right)              # смотрим на количество предельных эффектов, для которых 0
                                                                               # попал в доверительный интервал (FALSE - не попал)
   #Также, можем посчитать p_value для теста на равенство ME 0
left_tail <- pnorm(q = me_age, mean = 0, sd = me_age_std)                      # левый хвост                      
right_tail <- 1 - pnorm(q = me_age, mean = 0, sd = me_age_std)                 # правый хвост
p_value <- 2 * pmin(left_tail,right_tail)                                      # p-value
summary(p_value < 0.1)                                                         # смотрим долю значимых на уровне значимости 0.1
                                                                               # предельных эффектов
sum(p_value < 0.1) / length(p_value)
  # Предскажем верояности занятости для произвольного индивида
    # воспользуемся функцией pnorm - по умолчанию функция распределения 
    # стандартного нормального распределеиня, но можно задать и произвольные
    # значения математического ожидания и стандартого отклонения
pnorm(predict(model_probit,                                                    # модель, по которой осуществляется предсказание
        newdata = individual))                                                 # характеристики ранее созданного индивида
  #ЗАДАНИЯ
  #1. Рассчитайте средний предельный эффект брака на вероятность занятости.
  #2. Используя оценки пробит модели рассчитайте вероятность, с
  #   которой вы работаете (считайте, что у вас уже есть высшее образование)
  #3. Посчитайте медианные предельные эффекты для рассмотренных выше переменных 
  #4. Рассчитайте предельные эффекты для медианного индивида для рассмотренных выше переменных
  #5. Посчитайте, как изменится вероятность занятости медианного индивида через пять лет, при условии,
  #   что все его остальные характеристики останутся неизменными
  #6. Посчитайте долю предельных эффектов количества несовершеннолетних детей, значимых на уровне значимости 0.05
  #7. Проверьте, является ли значимым эффект возраста для медианного индивида на уровне значимости 0.01
  #8. Рассчитайте стандартные ошибки оценки среднего предельного эффекта и оценки предельного эффекта для среднего 
  #   индивида при помощи бутстрапа. Сравните полученные результаты с теми, что были получени при помощи дельта метода.
#--------------
#РАЗДЕЛ №3. Логит модель
#--------------
# Оценим логит модель
model_logit <- glm(work ~ age + I(age ^ 2) +         
                          educ_1 + educ_2 + educ_3 +
                          children_n_18 + marriage + I(marriage * children_n_18) +
                          BMI,
                   data = h[selection_condition,], 
                   family=binomial(link="logit"))
summary(model_logit)
# Запись коэффициентов и фрейма модели
model_logit_frame <- model_logit$model
model_logit_coef <- coef(model_logit)
# Предсказание
# Предсказанные значения латентной переменной
latent_values <- predict(model_logit)
summary(latent_values)
# ROC-кривая
rocCurve_logit <- roc(work ~ predict(model_logit, type=c("response")), data = model_logit_frame)
AUC_logit <- rocCurve_logit$auc
plot(rocCurve_logit)
  # Сравним с предыдущими моделями и убедимся, что кривые для логит и пробит моделей почти совпадают
plot(y=rocCurve$sensitivities, x = rocCurve$specificities, xlim = c(1, 0),                   
     xlab = "Специфичность", ylab="Чувствительность", col = "red", type = "line",
     main = "Зеленый - пробит, Красный - линейно-вероятностная модель, Голубой - логит")
lines(y=rocCurve_linear$sensitivities, x = rocCurve_linear$specificities, col = "green")
lines(y=rocCurve_logit$sensitivities, x = rocCurve_logit$specificities, col = "blue")
# Предельные эффекты нетрудно рассчитать по аналогии с пробит моделью,
# используя функции распределения и плотности логистического распределения
  # ЗАДАНИЯ
  # 1. Сравните долю верных предсказаний логит и пробит моделей
  # 2. Рассчитайте все предельные эффекты из предыдущего раздела для logit модели.
  #    Обратите внимание, что вместо функций dnorm и pnorm следует использовать функции
  #    plogis() и dlogis().
  # 3. Наглядно визуализируйте ROC кривые для логистической и пробит моделей на одном графике
# Отношение шансов - (вероятность успеха)/(вероятность неудачи)
  # Для переменных, входящих линейно (в данном случае только BMI и образование), справедливо следующее
odds_ratio_increase <- exp(model_logit_coef)                             # при изменении переменных на 1
odds_ratio_increase["BMI"]                                               # во сколько раз изменяется отношение шансов
delta_value <- 0.8                                                       # при изменении непрерывных переменных на delta_value
odds_ratio_BMI_delta_value <- exp(model_logit_coef["BMI"] * delta_value) # во сколько раз увеличится отношение вероятности быть
                                                                         # занятым к вероятности не быть занятым при увеличении
                                                                         # BMI на delta_value, при прочих равных
  # Убедимся в том, что это работает, на примере переменной BMI
  # Для начала рассчитаем вероятность занятости для индивида без приращения
prob_work <- plogis(predict(model_logit,                                           
                           newdata = data.frame("age" = 30,                              
                                                "educ_1" = 0, "educ_2" = 1, 
                                                "educ_3" = 0, "children_n_18" = 2,
                                                "marriage" = 1,
                                                "BMI" = 28)))
ods_work <- prob_work / (1 - prob_work) 
  # Теперь расчитаем эту вероятность в случае приращения
prob_work_delta <- plogis(predict(model_logit,                                           
                            newdata = data.frame("age" = 30,                              
                                                 "educ_1" = 0, "educ_2" = 1, 
                                                 "educ_3" = 0, "children_n_18" = 2,
                                                 "marriage" = 1,
                                                 "BMI" = 28 + delta_value)))
ods_work_delta <- prob_work_delta / (1 - prob_work_delta) 
  # Посмотрим, во сколько раз изменилось отношение шансов и сравним с полученным ранее результатом
c(ods_work_delta / ods_work, odds_ratio_BMI_delta_value)
  #Посмотрим на отношение шансов для возраста
delta_value <- 0.8
odds_ratio_age_delta_value <- exp(model_logit_coef["age"] * delta_value +
                                  model_logit_coef["I(age^2)"]  * delta_value ^ 2 +
                                  2 * model_logit_coef["I(age^2)"] * model_logit_frame$age * delta_value)
summary(odds_ratio_age_delta_value[model_logit_frame$age > total_effect_age_max])                          # проследим связь
summary(odds_ratio_age_delta_value[model_logit_frame$age < total_effect_age_max])                          #  предельным эффектом
  # Проверим полученный результат
# Для начала рассчитаем вероятность занятости для индивида без приращения
prob_work <- plogis(predict(model_logit,                                           
                            newdata = data.frame("age" = 30,                              
                                                 "educ_1" = 0, "educ_2" = 1, 
                                                 "educ_3" = 0, "children_n_18" = 2,
                                                 "marriage" = 1,
                                                 "BMI" = 28)))
ods_work <- prob_work / (1 - prob_work) 
# Теперь расчитаем эту вероятность в случае приращения
prob_work_delta <- plogis(predict(model_logit,                                           
                                  newdata = data.frame("age" = 30 + delta_value,                              
                                                       "educ_1" = 0, "educ_2" = 1, 
                                                       "educ_3" = 0, "children_n_18" = 2,
                                                       "marriage" = 1,
                                                       "BMI" = 28)))
ods_work_delta <- prob_work_delta / (1 - prob_work_delta) 
  # Посмотрим, во сколько раз изменилось отношение шансов и сравним с полученным ранее результатом
c(ods_work_delta / ods_work, odds_ratio_age_delta_value[model_logit_frame$age==30][1])
# Найдем реализацию оценки стандартной ошибки отношения шансов для рассмотренного выше индивида при помощи дельта метода
  # создадим функцию для расчета отношения шансов в зависимости от регрессионных коэффициентов
odds_ratio <- function(x,           # вектор регрессионных коэффициентов
                       individual)  # вектор переменных для индивида
{
  return(exp(sum(x * individual)))
}
  # создадим индивида, для которого будем рассчитывать отношение шансов
individual = data.frame("Intercept" = 1, 
                        "age" = 30, "age^2" = 30 ^ 2,                             
                        "educ_1" = 0, "educ_2" = 1, "educ_3" = 0, 
                        "children_n_18" = 2,
                        "marriage" = 1,
                        "marriage*chukdren_n_18" = 2 * 1,
                        "BMI" = 25)
  # посмотрим на отношение шансов
odds_ratio(x = coef(model_logit), individual = individual)
  # рассчитаем градиент численным методом
odds_ratio_grad <- grad(func = odds_ratio, x = coef(model_logit), individual = individual)
  # оценим асимптотическую дисперсию отношения шансов для индивида
odds_ratio_as_var <- t(odds_ratio_grad) %*% vcov(model_logit) %*% odds_ratio_grad
# Повторим расчеты используя бутстрап
odds_ratio_boot <- function(formula,     # используемая для построения модели формула
                   data,                 # данные
                   indices,              # вспомогательный аргумент для функции boot
                   individual)
{
  d <- data[indices,]                           
                                               
  model <- glm(formula, 
               family = binomial(link = "logit"), 
               data = d)          
  
  return(odds_ratio(coef(model), individual))   
}
model_probit_boot <- boot(data = h[selection_condition,], R = 200, statistic = odds_ratio_boot, 
                          formula = formula(model_logit), individual = individual)
odds_ratio_as_var_boot <- var(model_probit_boot$t)
  # построим бутстрапированный доверительный интервал
boot.ci(model_probit_boot,            # объект, содержащий результаты бутстрапирования
        type="perc",                  # указываем, что хотим получить перцентильный бутстрапированный интервал для оценок
        conf = c(0.9, 0.95, 0.99),    # указываем, каких уровней бутстрапированные доверительные интервалы нам нужны
        index = 1)                    # какого из коэффицеинтов доверительный интервал нам интересен (в данном случае для константы)
  # Сравним полученные результаты
c(odds_ratio_as_var, odds_ratio_as_var_boot)
  # ЗАДАНИЯ
  # 1. Рассчитайте отношения шансов для изменения уровня образования
  # 2. Рассчитайте отношения шансов для количества несовершеннолетних детей
  # 3. Введите в модель куб возраста и посчитайте среднее изменение отношения шансов для возраста, а также при помощи
  #    бутстрапа и дельта метода оцените его дисперсию