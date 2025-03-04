import pandas as pd
import xlwings as xw  # 导入xlwings模块
import re
from pathlib import Path
from openpyxl import load_workbook

# 指定文件路径
file_path = Path('DataFormated.xlsx')

# 检查文件是否存在
if file_path.is_file():
    print(f"文件 '{file_path}' 存在！")
else:
    print(f"文件 '{file_path}' 不存在！")
    app = xw.App(visible = True, add_book = False)  # 启动Excel程序，不新建工作簿
    workbook = app.books.add()  # 新建工作簿
    print(f"创建文件 '{file_path}'！")
    workbook.save(f'{file_path}')  # 保存新建的多个工作簿

    app.quit()

# 数据是已经使用allFileExtract.py截取的有效数据
# 直接将数据转换成需要的格式即可 信标号 车道号 时间戳 磁场值 车标签

# 读取 Excel 文件
df = pd.read_excel("allFileExtract.xlsx", sheet_name=0, header=None, engine='openpyxl')

# 一组数据占位18行
oneDataLength = 18

# 总计信标个数
allBeaconNum = 72

# 计算有效数据条数
valideDataNum = (df.shape[0]+1)/oneDataLength
# 输出 DataFrame 形状
print(f"DataFrame 共有 {df.shape[0]}行，{df.shape[1]} 列。计算有效数据条数为{valideDataNum}条")

# 提取信标号和车道号
def ExtractBeaconNumAndLaneNum(s):
    match1 = re.search(r'(\d{1,2})$', s)  # 匹配结尾 1 或 2 位数字
    match2 = re.search(r'-(.*?)-', s)  # 匹配 - 之间的内容
    return match1.group(1) if match1 else None,match2.group(1) if match2 else None

# 中间值接受现在的写入位置
tempWritePos = 1


# 获取特定单元格数据，例如获取第一行第一列的数据
for i in range(int(valideDataNum)):  # 0 到 82950

    # 临时存储处理的行数
    tempNum = i * oneDataLength

    cell_value = df.iloc[tempNum, 0] # 行索引i，列索引0
    cell_value = str(cell_value)  # 确保 cell_value 是字符串类型

    print(f"第 {i + 1} 行字符串车牌号为: {cell_value}")

    for j in range(1,allBeaconNum):
        # NaN 值判断
        if pd.isna(df.iloc[tempNum, j]) or df.iloc[tempNum, j] == "":
            continue
        else:
            #print(f"{df.iloc[tempNum, j]}")
            # 提取信标号和车道号
            beaconNum,laneNum = ExtractBeaconNumAndLaneNum(df.iloc[tempNum, j])
            # 提取时间戳
            timeStamp = df.iloc[tempNum + 2, j]
            # 提取磁场值
            magneticFieldValue = df.iloc[tempNum + 4, j]
            #print(f"信标号：{beaconNum}，车道号：{laneNum}，时间戳为：{timeStamp}，磁场值为：{magneticFieldValue}")
            # 读取 Excel 文件到 DataFrame
            df1 = pd.read_excel(file_path, sheet_name=0, header=None, engine='openpyxl')

            # 修改 DataFrame 中的特定单元格
            df1.loc[tempWritePos, 0] = int(beaconNum)
            df1.loc[tempWritePos, 1] = int(laneNum)
            df1.loc[tempWritePos, 2] = int(timeStamp)
            df1.loc[tempWritePos, 3] = int(magneticFieldValue)
            df1.loc[tempWritePos, 4] = int(i)
            tempWritePos = tempWritePos + 1


            # 将修改后的 DataFrame 写回 Excel 文件
            df1.to_excel(file_path, index=False, header=False)
            #print(f"写入数据成功！")









