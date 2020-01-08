# Описание

Разбор форматов файлов игр на движке **Strorm 1**: **Корсары Проклятье дальних морей** (2000) , **Век парусников 2** (2001) и **Рыцари Морей** (2002), а также **Storm 2**: **Корсары 2 Пираты Карибского моря** (2003),  **Корсары 3** (2006).

* Документация с описание форматов ведется на [WIKI](https://github.com/AlexKimov/seadogs-file-formats/wiki). 
* Следить за общим прогрессом по форматам можно здесь [Форматы](https://github.com/AlexKimov/seadogs-file-formats/projects/1).

Текущий прогресс по форматам:

| Формат  | Прогресс | Комментарий | 
| :-- | :-------- | :------ |
| TX | 100% |  |
| TF | 100% |  |
| PAK | 100% |  |
| IDF | 100% |  |
| CFF | >90% |  |
| CLF | >90% |  |
| SC | >80% |  |
| CMP | >90% |  |
| DLT | 100% |  |
| DLM | 100% |  |
| DEF | >90% |  |
| ANI | >90% |  |
| AN | >90% |  |
| ANI | >70% |  |
| SLS | >90% |  |
| ZAP | >90% |  |
| SHP |  |  |
| GM | >70% |  |

\* прогресс условный и скорее отражает сами данные, насколько определенные структуры позволяют манипулировать, изменять игру в целом, а не общий прогресс как таковой.
  
##### Текущие планы

1. Программы/плагины для импорта/экспорта из исходных форматов в промежуточные и обратно.

2. Доработка шаблонов и документации на форматы.

##### Дополнительные ссылки

1. Группа ВК [Моддинг Корсары, Век Парсуников 2, Рыцари Морей](https://vk.com/seadogsrevisited) - привествуются вопросы и любая помощь по проекту.

## Игры

Список всех игр и форматов используемых файлов.

| №   | Название | Год | Форматы | 
| :-- | :-------- | :------ | :------ |
| 1 | Корсары Проклятье Дальних морей  | 2000   | .ani, .cff, .clf, .tf, .def, .idf, .sls, .dlt, .dlm |
| 2 | Век парусников 2  | 2001  | .cmp, .tf, .pak, .cff, .clf, .sc |
| 3 | Рыцари Морей  | 2002  | .cmp, .tf, .pak, .cff, .clf, .sc |
| 4 | Корсары 2 Пираты Карибского моря  | 2003  | .gm, .an, .zap, .tx  |
| 5 | Корсары 3 | 2006  | .gm, .an, .zap, .tx   |

## Шаблоны, описание форматов

Таблицы с описанием формата файла по играм. **.bt** - файл шаблона программы 010editor, содержит описание структур формата в стиле языка C.

### 1. Корсары Проклятье Дальних морей

| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ANI.bt)  | [Формат файла ANI](https://github.com/AlexKimov/seadogs-file-formats/wiki/ANI-File-Format-Rus)   | Анимация сцены |
| 2  | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  | [Формат файла CFF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CFF-File-Format-Rus) | 3D   | 
| 3  | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) | [Формат файла CLF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CLF-File-Format-Rus)  | 3D |
| 4  | DEF/.def  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/18)   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DEF.bt) |   | Файл описания для составных объектов (корабли и др.) |
| 5  | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](htps://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/IDF.bt) | [Формат файла IDF](https://github.com/AlexKimov/seadogs-file-formats/wiki/IDF-File-Format-Rus)  | Свойства объектов |
| 6  | DLM/.dlm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/15)   | [DLM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DLM.bt)  | [Формат файла DLM](https://github.com/AlexKimov/seadogs-file-formats/wiki/DLM-File-Format-Rus) | Маска острова |
| 7  | DLT/.dlt  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/9)   | [DLT.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DLT.bt)  | [Формат файла DLT.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DLT.bt)  | z-buffer ?  |
| 8  | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   | [Формат файла TF](https://github.com/AlexKimov/seadogs-file-formats/wiki/TF-File-Format-Rus) | Текстуры  |
| 9  | SLS/.sls    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/11)   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SLS.bt)   |   | Реи |

### 2. Век парусников 2
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1  | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  | [Формат файла CFF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CFF-File-Format-Rus) | 3D   | 
| 2  | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) | [Формат файла CLF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CLF-File-Format-Rus)  | 3D |
| 3   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CMP.bt) |  [Формат файла CMP](https://github.com/AlexKimov/seadogs-file-formats/wiki/CMP-File-Format-Rus) | Параметры кампании  |
| 4  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/PAK.bt)  | [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus) | Файл архива игры Век парусников 2: 3d модели, текстуры, программы(!), шрифты  | 
| 5  | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   | [Формат файла TF](https://github.com/AlexKimov/seadogs-file-formats/wiki/TF-File-Format-Rus) | Текстуры  |
| 6 | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SC.bt)  |  |  Параметры корабля  |

### 3. Рыцари морей
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1  | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  | [Формат файла CFF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CFF-File-Format-Rus) | 3D   | 
| 2  | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) | [Формат файла CLF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CLF-File-Format-Rus)  | 3D |
| 3   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CMP.bt) |  [Формат файла CMP](https://github.com/AlexKimov/seadogs-file-formats/wiki/CMP-File-Format-Rus) | Параметры кампании  |
| 4 | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/PAK(PB).bt)| [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus)  | Файл архива игры Рыцари морей: 3d модели, текстуры, программы(!), шрифты | 
| 5  | TF/.tf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   | [Формат файла TF](https://github.com/AlexKimov/seadogs-file-formats/wiki/TF-File-Format-Rus) | Текстуры  |
| 6 | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SC.bt)  |  |  Параметры корабля   |

### 4. Корсары 2 Пираты Карибского Моря
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/12) |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/AN.bt)  |   | Анимация персонажа |
| 2   | GM/.gm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/13) |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/GM.bt)  |  | 3D объекты: Персонажи, уровни. |
| 3  | TX/.tx    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/14) |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TX.bt)   | [Формат файла TX](https://github.com/AlexKimov/seadogs-file-formats/wiki/TX-File-Format-Rus) | Текстуры  |
| 4  | ZAP/.zap    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/17)  |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ZAP.bt)   | [Формат файла ZAP](https://github.com/AlexKimov/seadogs-file-formats/wiki/ZAP-File-Format-Rus) | Маска острова  |

### 5. Корсары 3
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/12) |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/AN.bt)  |   | Анимация персонажа |
| 2   | GM/.gm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/13) |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/GM.bt)  |  | 3D объекты: Персонажи, уровни. |
| 3  | TX/.tx    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/14) |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TX.bt)   | [Формат файла TX](https://github.com/AlexKimov/seadogs-file-formats/wiki/TX-File-Format-Rus) | Текстуры  |
| 4  | ZAP/.zap    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/17)  |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ZAP.bt)   | [Формат файла ZAP](https://github.com/AlexKimov/seadogs-file-formats/wiki/ZAP-File-Format-Rus) | Маска острова  |


## Скрипты / Плагины / Программы

Для запуска скрипта требуется программа 010Editor.

### 010Editor
| №   | Название | Описание | 
| :-- | :-------- | :------ |
| 1 | [DecodeDAT.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/decodeDAT.1sc)  | Скрипт для шифрования/расшифровки **.dat** файлов игры Век Парсуников 2 |
| 2 | [UnpackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/UnpackPAK.1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Век Парсуников 2 |
| 3 | [UnpackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/UnpackPAK(PB).1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Рыцари морей |
| 4 | [DecodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/decodeActionFile.1sc) | Скрипт (010 Editor) для расшифровки **.a** файлов игры Корсары ПДМ |
| 5 | [EncodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/encodeActionFile.1sc)  | Скрипт для шифрования **.a** файлов игры Корсары ПДМ |
| 6 | [PackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/PackPAK.1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Век Парсуников 2 |
| 7 | [PackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/PackPAK(PB).1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Рыцари морей |
| 8 | [TFtoTGA.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/TFtoTGA.1sc) | конвертирование файлов **.tf** в .bmp |

### Noesis

Для запуска скрита требуется программа Noesis.

* [fmt_sd_tf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_tf.py) - скрипт для просмотра и сохранения файлов в формат **TF** (Корсары ПДМ)
* [fmt_sd_dlt.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_dlt.py) - скрипт для просмотра и сохранения файлов в формат **DLT** (Корсары ПДМ)
* [fmt_sd_cff_clf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_cff_clf.py) - скрипт для просмотра **CFF** файлов (Корсары ПДМ)
* [fmt_aos2_pak.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_aos2_pak.py) - скрипт для распаковки **PAK** файлов (Век Парсуников 2)
* [fmt_sd2_tx.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd2_tx.py) - скрипт для просмотра **TX** файлов (Корсары 2, 3)
* [fmt_sd2_zap.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd2_zap.py) - скрипт для просмотра **ZAP** файлов (Корсары 2, 3)

### 3dsMax

Для запуска скрипта требуется программа 3dsMax версии 2010 и выше.
    
* [cff_clf_import.zip](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/3dsmax/cff_clf/build/cff_clf_import.zip) - импорт моделей с анимациями (Корсары, Век Парсуников 2, Рыцари Морей)
* [ani_import.zip](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/3dsmax/cff_clf/build/ani_import.zip) - импорт анимированных сцен .ani (только модели и анимации)

***

# About

**Sea dogs** (2000), **Age of Sale 2** (2001), **Privateer’s Bounty: Age of Sail 2** (2002), 
**Pirates of the Caribbean** (2003), **Age of Pirates: Caribbean Tales** (2006) games file formats.

## Games

| №   | Title | Year |Formats | 
| :-- | :-------- | :------ | :------ |
| 1 |  Sea Dogs  | 2000   | .ani, .cff, .clf, .tf, .def, .idf, .sls |
| 2 | Age of Sale 2  | 2001  | .cmp, .tf, .pak, .cff, .clf |
| 3 | Privateer’s Bounty: Age of Sail 2  | 2002  | .cmp, .tf, .pak, .cff, .clf |
| 4 | Pirates of the Caribbean  | 2003  | .gm, .an, .zap, .tx  |
| 5 | Age of Pirates: Caribbean Tales | 2006  | .gm, .an, .zap, .tx   |

## Formats and templates

### 1. Sea Dogs

| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1  | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ANI.bt)  |  | Animated scene |
| 2  | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  |  | 3D Model   | 
| 3  | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) |  | 3D Model |
| 4  | DEF/.def  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/18)   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DEF.bt) |  | Object definition |
| 5  | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](htps://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/IDF.bt)  |  | Game object properties table |
| 6  | DLM/.dlm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/15)   |   |  | Island Mask |
| 7  | DLT/.dlt  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/9)   |  [DLT.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/DLT.bt) |  | ? |
| 8  | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   |  | Texture file  |
| 9  | SLS/.sls    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/11)   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SLS.bt)   |   | Yard |

### 2. Age of Sale 2
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  |  | 3D Models   | 
| 2   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) |   | 3D Models |
| 3   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CMP.bt) |  | Age of Sale 2 campaign file |
| 4  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/PAK.bt)  |  | Age of Sail 2 Game archive: 3d models, textures, executables, fonts   | 
| 5 | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SC.bt)  |  |  Ship params  |
| 6   | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   |  | Texture file  |

### 3. Privateer’s Bounty: Age of Sail 2
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CFF.bt)  |  | 3D Models   | 
| 2   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CLF.bt) |   | 3D Models |
| 3   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/CMP.bt) |  | Privateer’s Bounty campaign file |
| 4  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/PAK(PB).bt) |  | Privateer’s Bounty Game archive: 3d models,  textures, executables, fonts   | 
| 5 | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/SC.bt)  |  |  Ship params   |
| 6   | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TF.bt)   |  | Texture file  |

### 4. Pirates of the Caribbean
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/12) |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/AN.bt)  |   | Animation |
| 2   | GM/.gm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/13) |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/GM.bt)  |  | 3D object |
| 3  | TX/.tx    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/14) |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TX.bt)   |  | Texture file  |
| 4  | ZAP/.zap    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/17)  |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ZAP.bt)   |  | Island mask file  |

### 5. Age of Pirates: Caribbean Tales
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/12) |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/AN.bt)  |   | Animation |
| 2   | GM/.gm  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/13) |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/GM.bt)  |  | 3D objects |
| 3  | TX/.tx    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/14) |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/TX.bt)   |  | Texture file  |
| 4  | ZAP/.zap    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/17)  |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/010Editor/ZAP.bt)   |  | Island mask file  |

## Scripts
| №   | File | Decription | 
| :-- | :-------- | :------ |
| 1 | [DecodeDAT.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/decodeDAT.1sc)  | Age of Sail 2 **.dat** file decode/encode script for 010 editor |
| 2 | [UnpackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/UnpackPAK.1sc) | Age of Sail 2 **.pak** file  unpack script for 010 editor |
| 3 | [UnpackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/UnpackPAK(PB).1sc) | Privateer’s Bounty **.pak** file unpack script for 010 editor |
| 4 | [EncodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/encodeActionFile.1sc) | Encode action file **.a** (Sea Dogs) |
| 5 | [DecodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/decodeActionFile.1sc) | Decode action file **.a** (Sea Dogs) |
| 6 | [PackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/PackPAK.1sc) | Pack to **.pak** archive (Age of Sail 2) |
| 7 | [PackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/PackPAK(PB).1sc) | Pack to **.pak** archive (Privateer’s Bounty) |
| 8 | [TFtoTGA.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/010editor/TFtoTGA.1sc) | **.tf** file to .bmp |

### Noesis
* [fmt_sd_tf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_tf.py) - script to view and save **TF** files (Sea Dogs 1)
* [fmt_sd_dlt.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_dlt.py) - script to view and save **DLT** files (Sea Dogs 1)
* [fmt_sd_cff_clf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd_cff_clf.py) - script to view **CFF** files (Sea Dogs 1)
* [fmt_aos2_pak.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_aos2_pak.py) - script to unpack **PAK** files (Age of Sail 2)
* [fmt_sd2_tx.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd2_tx.py) - script to view **TX** files (Sea Dogs 2, 3)
* [fmt_sd2_zap.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/noesis/fmt_sd2_zap.py) - script to view **ZAP** files (Sea Dogs 2, 3)

### 3dsMax
* [cff_clf_import.zip](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/3dsmax/cff_clf/build/cff_clf_import.zip) - model import (Sea Dogs 1, Age of Sail 2)
* [ani_import.zip](https://github.com/AlexKimov/seadogs-file-formats/blob/master/plugins/3dsmax/cff_clf/build/ani_import.zip) - import .ami files (animated scenes)
