这个是期末写了超级久的大作业“医疗选址问题”，主要使用了Haversine算法来计算地球上两个点之间的距离，并使用了智能鱼群算法（AFSA) 来进行了地址的寻优
主要文件如下：
# readme

## 程序配置环境如下：

- Python 3.8.8

- numpy 
- matplotlib
- Basemap

```python
pip install Basemap
```

## Contents

- AFSA.py

  -  实现鱼个体的功能

    ```python
    class Afish():
    ```

  -  AFSA  鱼群智能和优化

    ```
    class AFSA():
    ```

- plot_boundary.py

  - ```python
    def plot_boundary(x)
    ```

- main.py

  - 执行绘制地图的操作

- cities.txt

  - 将.xlsx文件转换为.txt形式，方便numpy来进行读取

- Basemap_Package
  - 存储地图的信心
- plot
  - 绘制的流程图
