import xlwings as xw  # 导入xlwings模块

from pathlib import Path

# 指定文件路径
file_path = Path('example.xlsx')

# 检查文件是否存在
if file_path.is_file():
    print(f"文件 '{file_path}' 存在！")
else:
    print(f"文件 '{file_path}' 不存在！")
    app = xw.App(visible = True, add_book = False)  # 启动Excel程序，不新建工作簿
    workbook = app.books.add()  # 新建工作簿
    workbook.save(f'{file_path}')  # 保存新建的多个工作簿

    app.quit()