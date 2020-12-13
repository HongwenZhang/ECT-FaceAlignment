# Combining Data-driven and Model-driven Methods for Robust Facial Landmark Detection

This is the demo code for the ECT approach described in [Combining Data-driven and Model-driven Methods for Robust Facial Landmark Detection](https://arxiv.org/pdf/1611.10152.pdf).
<p align="center" width="100%">
    <img src="https://hongwenzhang.github.io/images/faceAlign.png" alt="ECT"> 
</p>

## Requirements

- python 2.7

## Instructions

You may need to compile the caffe firstly before you run the demo code. The pre-trained caffemodel could be downloaded from [here](https://drive.google.com/drive/folders/1DLrrY2gdKht8YJ8fwFZanZSICRKKRurt).

```
cd caffe/python
for req in $(cat requirements.txt); do pip install $req; done
cd ..
make all
make pycaffe
cd ..
cd landmark_detection
python run_demo.py --imgDir path/to/you/testing/images --model path/to/the/pretrained/caffemodel --verbose True
```

## Citation
If this work is helpful in your research, please cite the following paper.
```
@article{zhang2018combining,
  title={Combining data-driven and model-driven methods for robust facial landmark detection},
  author={Zhang, Hongwen and Li, Qi and Sun, Zhenan and Liu, Yunfan},
  journal={IEEE Transactions on Information Forensics and Security},
  volume={13},
  number={10},
  pages={2409--2422},
  year={2018},
  publisher={IEEE}
}
```

## Acknowledgment

The code is developed upon [Caffe-heatmap](https://github.com/tpfister/caffe-heatmap), [Menpo](https://github.com/menpo/menpo), and [Menpofit](https://github.com/menpo/menpofit). Thanks to the original authors.

ECT was extended to detect facial landmarks on artistic portraits by Yaniv et al. Have a look at their code [here](https://github.com/papulke/face-of-art).
[![The Face Of Art](https://hongwenzhang.github.io/images/face-of-art.png "The Face Of Art")](https://faculty.idc.ac.il/arik/site/foa/face-of-art.asp)

