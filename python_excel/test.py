import pandas as pd

# 读取 Excel 文件
df = pd.read_excel('validData.xlsx',sheet_name=0, engine='openpyxl',header=None)

# # 对单个单元格进行加法操作：第1行第1列 + 第1行第2列 -> 第1行第3列
# df.iloc[56, 1] = df.iloc[0, 0] + df.iloc[0, 1]
#
# # 对单个单元格进行减法操作：第2行第1列 - 第2行第2列 -> 第2行第3列
# df.iloc[1, 3] = df.iloc[1, 0] - df.iloc[1, 1]

# 查看操作后的 DataFrame
print(abs(int(df.iloc[56, 1]) - int(df.iloc[74, 1])))


# 将结果写回到新的 Excel 文件
# df.to_excel('test.xlsx', index=False)

