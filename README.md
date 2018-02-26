# Combining Data-driven and Model-driven Methods for Robust Facial Landmark Detection

This is the demo code for [Combining Data-driven and Model-driven Methods for Robust Facial Landmark Detection](https://arxiv.org/abs/1611.10152).

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
If this work is helpful in your research, please cite the following paper
```
@article{zhang2018combining,
  title={Combining Data-driven and Model-driven Methods for Robust Facial Landmark Detection},
  author={Zhang, Hongwen and Li, Qi and Sun, Zhenan and Liu, Yunfan},
  journal={IEEE Transactions on Information Forensics and Security},
  year={2018}
}
```

## Acknowledgment

The code is developed upon [Caffe-heatmap](https://github.com/tpfister/caffe-heatmap), [Menpo](https://github.com/menpo/menpo), and [Menpofit](https://github.com/menpo/menpofit). Thanks to the original authors.
