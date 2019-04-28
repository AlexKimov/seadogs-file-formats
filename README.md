# Описание

Разбор форматов файлов игр на движке **Strorm 1**: **Корсары Проклятье дальних морей** (2000) , **Век парусников 2** (2001) и **Рыцари Морей** (2002), **Storm 2**: **Корсары 2 Пираты Карибского моря** (2003),  **Корсары 3** (2006).

Описание форматов [см. WIKI](https://github.com/AlexKimov/seadogs-file-formats/wiki). Текущий прогресс см. [Issues](https://github.com/AlexKimov/seadogs-file-formats/issues).

#### Текущие планы

1. Программы для импорта/экспорта из исходных форматов в промежуточные и обратно.

2. Доработка шаблонов и документации на форматы.

### Игры

| №   | Название | Год | Форматы | 
| :-- | :-------- | :------ | :------ |
| 1 | Корсары Проклятье Дальних морей / Sea Dogs  | 2000   | .ani, .cff, .clf, .sc, .tf, .def, .idf, .sls, .dlt, .dlm |
| 2 | Век парусников 2  | 2001  | .cmp, .tf, .pak, .cff, .clf |
| 3 | Рыцари Морей  | 2002  | .cmp, .tf, .pak, .cff, .clf |
| 4 | Корсары 2 Пираты Карибского моря  | 2003  | .gm, .an, .zap, .tx  |
| 5 | Корсары 3 | 2006  | .gm, .an, .zap, .tx   |

### Скрипты

#### 010Editor

| №   | Название | Описание | 
| :-- | :-------- | :------ |
| 1 | [DecodeDAT.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeDAT.1sc)  | Скрипт для шифрования/расшифровки **.dat** файлов игры Век Парсуников 2 |
| 2 | [UnpackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK.1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Век Парсуников 2 |
| 3 | [UnpackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK(PB).1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Рыцари морей |
| 4 | [DecodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeActionFile.1sc) | Скрипт (010 Editor) для расшифровки **.a** файлов игры Корсары ПДМ |
| 5 | [EncodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/encodeActionFile.1sc)  | Скрипт для шифрования **.a** файлов игры Корсары ПДМ |
| 6 | [PackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK.1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Век Парсуников 2 |
| 7 | [PackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK(PB).1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Рыцари морей |
| 8 | [TFtoTGA.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/TFtoTGA.1sc) | конвертирование файлов .tf в .bmp |

#### Noesis
* [fmt_sd_tf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_tf.py) - скрипт для просмотра и сохранения файлов в формат **TF** (Корсары ПДМ)
* [fmt_sd_dlt.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_dlt.py) - скрипт для просмотра и сохранения файлов в формат **DLT** (Корсары ПДМ)
* [fmt_sd_cff_clf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_cff_clf.py) - скрипт для просмотра **CFF** файлов (Корсары ПДМ)
* [fmt_aos2_pak.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_aos2_pak.py) - скрипт для распаковки **PAK** файлов (Век Парсуников 2)
* [fmt_sd2_tx.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd2_tx.py) - скрипт для распаковки **PAK** файлов (Век Парсуников 2)

### Шаблоны, описание форматов
| №   | Формат | Прогресс | Шаблон (010 Editor) | WIKI | Краткое описание |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  |  |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/AN.bt)  |   | Анимация персонажа |
| 2   | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ANI.bt)  | [Формат файла ANI](https://github.com/AlexKimov/seadogs-file-formats/wiki/ANI-File-Format-Rus)   | Анимация сцены |
| 3   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CFF.bt)  | [Формат файла CFF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CFF-File-Format-Rus) | 3D Модели, игровой уровень  | 
| 4   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CLF.bt) | [Формат файла CLF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CLF-File-Format-Rus)  | 3D Модели |
| 5   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CMP.bt) |  [Формат файла CMP](https://github.com/AlexKimov/seadogs-file-formats/wiki/CMP-File-Format-Rus) | Файл компании игры Век Парусников 2 и Рыцари морей  | 
| 6  | DEF/.def  | []()   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DEF.bt) |   | |
| 7  | DLM/.dlm  | []()   |   |  [Формат файла DLM](https://github.com/AlexKimov/seadogs-file-formats/wiki/DLM-File-Format-Rus) | Маска острова |
| 8  | DLT/.dlt  | []()   |  [DLT.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DLT.bt) |  [Формат файла DLT](https://github.com/AlexKimov/seadogs-file-formats/wiki/DLT-File-Format-Rus)  | ? |
| 9   | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/IDF.bt)  | [Формат файла IDF](https://github.com/AlexKimov/seadogs-file-formats/wiki/IDF-File-Format-Rus) | Таблица объектов и их свойств | 
| 10   | GM/.gm  |  |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/GM.bt)  |  | 3D объекты: Персонажи, уровни. |
| 11  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK.bt)  | [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus) | Файл архива игры Век парусников 2: 3d модели, текстуры, программы(!), шрифты  | 
| 12 | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK(PB).bt)| [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus)  | Файл архива игры Рыцари морей: 3d модели, текстуры, программы(!), шрифты | 
| 13 | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SC.bt)  |  |  Параметры корабля (игра Корсары)  |
| 14 | SLS/.sls    | []()   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SLS.bt)   |   ||
| 15  | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TF.bt)   | [Формат файла TF](https://github.com/AlexKimov/seadogs-file-formats/wiki/TF-File-Format-Rus) | Файл текстур Корсары 1, Век парсуников  |
| 16  | TX/.tx    |   |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TX.bt)   | [Формат файла TX](https://github.com/AlexKimov/seadogs-file-formats/wiki/TX-File-Format-Rus) | Файл текстур Корсары 2/3  |
| 17  | ZAP/.zap    |   |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ZAP.bt)   | [Формат файла ZAP](https://github.com/AlexKimov/seadogs-file-formats/wiki/ZAP-File-Format-Rus) | Маска острова  |

***

# About

**Sea dogs** (2000), **Age of Sale 2** (2001), **Privateer’s Bounty: Age of Sail 2** (2002), 
**Pirates of the Caribbean** (2003), **Age of Pirates: Caribbean Tales** (2006) games file formats.

### Games

| №   | Title | Year |Formats | 
| :-- | :-------- | :------ | :------ |
| 1 |  Sea Dogs  | 2000   | .ani, .cff, .clf, .sc, .tf, .def, .idf, .sls |
| 2 | Age of Sale 2  | 2001  | .cmp, .tf, .pak, .cff, .clf |
| 3 | Privateer’s Bounty: Age of Sail 2  | 2002  | .cmp, .tf, .pak, .cff, .clf |
| 4 | Pirates of the Caribbean  | 2003  | .gm, .an, .zap, .tx  |
| 5 | Age of Pirates: Caribbean Tales | 2006  | .gm, .an, .zap, .tx   |

### Formats and templates
| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | AN/.an  |  |  [AN.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/AN.bt)  |   | Animation |
| 2   | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ANI.bt)  |    | |
| 3   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CFF.bt)  | | 3D Models   | 
| 4   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CLF.bt) |   | |
| 5   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CMP.bt) |  | Privateer’s Bounty campaign file |
| 6  | DEF/.def  | []()   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DEF.bt) |   | |
| 7  | DLM/.dlm  | []()   |   |  | Island Mask |
| 8  | DLT/.dlt  | []()   |  [DLT.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DLT.bt) |   | ? |
| 9   | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](htps://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/IDF.bt)  |  | Game object properties table |
| 10   | GM/.gm  |  |  [GM.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/GM.bt)  |  | 3D objects |
| 11  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK.bt)  | | Age of Sail 2 Game archive: 3d models, textures, executables, fonts   | 
| 12  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK(PB).bt) | | Privateer’s Bounty Game archive: 3d models,  textures, executables, fonts   | 
| 13  | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/9)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SC.bt)  | | Age of Sail 2/Privateer’s Bounty Scenario file | 
| 14  | SLS/.sls    | []()   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SLS.bt)   |   ||
| 15   | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TF.bt)   | | Texture file  |
| 16  | TX/.tx    |   |  [TX.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TX.bt)   | | Texture file  |
| 17  | ZAP/.zap    |   |  [ZAP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ZAP.bt)   | | Island mask file  |

### Scripts
| №   | File | Decription | 
| :-- | :-------- | :------ |
| 1 | [DecodeDAT.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeDAT.1sc)  | Age of Sail 2 **.dat** file decode/encode script for 010 editor |
| 2 | [UnpackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK.1sc) | Age of Sail 2 **.pak** file  unpack script for 010 editor |
| 3 | [UnpackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK(PB).1sc) | Privateer’s Bounty **.pak** file unpack script for 010 editor |
| 4 | [EncodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/encodeActionFile.1sc) | Encode action file .a (Sea Dogs) |
| 5 | [DecodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeActionFile.1sc) | Decode action file .a (Sea Dogs) |
| 6 | [PackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK.1sc) | Pack to .pak archive (Age of Sail 2) |
| 7 | [PackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK(PB).1sc) | Pack to .pak archive (Privateer’s Bounty) |
| 8 | [TFtoTGA.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/TFtoTGA.1sc) | .tf file to .bmp |

#### Noesis
* [fmt_sd_tf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_tf.py) - script to view and save **TF** files (Sea Dogs 1)
* [fmt_sd_dlt.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_dlt.py) - script to view and save **DLT** files (Sea Dogs 1)
* [fmt_sd_cff_clf.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_sd_cff_clf.py) - script to view **CFF** files (Sea Dogs 1)
* [fmt_aos2_pak.py](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/noesis/fmt_aos2_pak.py) - script to unpack **PAK** files (Age of Sail 2)
