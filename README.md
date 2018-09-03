# Описание

Форматы файлов игр **Корсары Проклятье дальних морей** (2000) , **Век парусников 2** (2001) и **Рыцари Морей** (2002). 

Описание форматов [см. WIKI](https://github.com/AlexKimov/seadogs-file-formats/wiki). Текущий прогресс см. [Issues](https://github.com/AlexKimov/seadogs-file-formats/issues).

#### Текущие планы

1. Программы для импорта/экспорта из исходных форматов в промежуточные и обратно.

2. Доработка швблново и документации на форматы.

### Инструменты
| №   | Название | Описание | 
| :-- | :-------- | :------ |
| 1 | [DecodeDAT.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeDAT.1sc)  | Скрипт для шифрования/расшифровки **.dat** файлов игры Век Парсуников 2 |
| 2 | [UnpackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK.1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Век Парсуников 2 |
| 3 | [UnpackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/UnpackPAK(PB).1sc) | Скрипт (010 Editor) для распаковки архивов **.pak** игры Рыцари морей |
| 4 | [DecodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/decodeActionFile.1sc) | Скрипт (010 Editor) для расшифровки **.a** файлов игры Корсары ПДМ |
| 5 | [EncodeActionFile.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/encodeActionFile.1sc)  | Скрипт для шифрования **.a** файлов игры Корсары ПДМ |
| 6 | [PackPAK.1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK.1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Век Парсуников 2 |
| 7 | [PackPAK(PB).1sc](https://github.com/AlexKimov/seadogs-file-formats/blob/master/scripts/PackPAK(PB).1sc) | Скрипт (010 Editor) для запаковки файлов в архив **.pak** игры Рыцари морей |


### Форматы файлов
| №   | Формат | Прогресс | Шаблон (010 Editor) | WIKI | Краткое описание |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ANI.bt)  | [Формат файла ANI](https://github.com/AlexKimov/seadogs-file-formats/wiki/ANI-File-Format-Rus)   | Анимация сцены |
| 2   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CFF.bt)  | [Формат файла CFF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CFF-File-Format-Rus) | 3D Модели, игровой уровень  | 
| 3   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CLF.bt) | [Формат файла CLF](https://github.com/AlexKimov/seadogs-file-formats/wiki/CLF-File-Format-Rus)  | 3D Модели |
| 4   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CMP.bt) |  [Формат файла CMP](https://github.com/AlexKimov/seadogs-file-formats/wiki/CMP-File-Format-Rus) | Файл компании игры Век Парусников 2 и Рыцари морей  | 
| 5  | DEF/.def  | []()   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DEF.bt) |   | |
| 6   | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/IDF.bt)  | [Формат файла IDF](https://github.com/AlexKimov/seadogs-file-formats/wiki/IDF-File-Format-Rus) | Таблица объектов и их свойств | 
| 7  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK.bt)  | [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus) | Файл архива игры Век парусников 2: 3d модели, текстуры, программы(!), шрифты  | 
| 8  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK(PB).bt)| [Формат файла PAK](https://github.com/AlexKimov/seadogs-file-formats/wiki/PAK-File-Format-Rus)  | Файл архива игры Рыцари морей: 3d модели, текстуры, программы(!), шрифты | 
| 9  | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/7)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SC.bt)  |  |  Параметры корабля (игра Корсары)  |
| 10  | SLS/.sls    | []()   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SLS.bt)   |   ||
| 11   | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TF.bt)   | [Формат файла TF](https://github.com/AlexKimov/seadogs-file-formats/wiki/TF-File-Format-Rus) | Файл текстур  |

***

# About

**Sea dogs** (2000), **Age of Sale 2** (2001), **Privateer’s Bounty: Age of Sail 2** (2002) games file formats.

| №   | Format/Ext | Progress | Template (010 Editor) | WIKI | Description |
| :-- | :-------- | :------ | :------- | :--   | :--   |
| 1   | ANI/.ani  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/6)   |  [ANI.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/ANI.bt)  |    | |
| 2   | CFF/.ccf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/4)   |  [CFF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CFF.bt)  | | 3D Models   | 
| 3   | CLF/.clf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/5)   |  [CLF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CLF.bt) |   | |
| 4   | CMP/.cmp  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/8)   |  [CMP.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/CMP.bt) |  | Privateer’s Bounty campaign file |
| 5  | DEF/.def  | []()   |  [DEF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/DEF.bt) |   | |
| 6   | IDF/.idf  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/3)  |  [IDF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/IDF.bt)  |  | Game object properties table |
| 7  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK.bt)  | | Age of Sail 2 Game archive: 3d models, textures, executables, fonts   | 
| 8  | PAK/.pak  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/2)   |  [PAK(PB).bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/PAK(PB).bt) | | Privateer’s Bounty Game archive: 3d models,  textures, executables, fonts   | 
| 9  | SC/.sc  | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/9)   |  [SC.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SC.bt)  | | Age of Sail 2/Privateer’s Bounty Scenario file | 
| 10  | SLS/.sls    | []()   |  [SLS.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/SLS.bt)   |   ||
| 11   | TF/.tf    | [Issue](https://github.com/AlexKimov/seadogs-file-formats/issues/1)   |  [TF.bt](https://github.com/AlexKimov/seadogs-file-formats/blob/master/templates/TF.bt)   | | Texture file  |

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


