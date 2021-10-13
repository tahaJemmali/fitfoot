import numpy as np
import os
import six.moves.urllib as urllib
import sys
import json
import tarfile
import tensorflow as tf
import zipfile
import cv2
import pathlib
import base64
import io

p_rougeur = float(-1)
detection = 'false'
image1 = 'null'
image2 = 'null'

from collections import defaultdict
from io import StringIO
from matplotlib import pyplot as plt
from PIL import Image
from IPython.display import display

from object_detection.utils import ops as utils_ops
from object_detection.utils import label_map_util
from object_detection.utils import visualization_utils as vis_util

# patch tf1 into `utils.ops`
utils_ops.tf = tf.compat.v1

# Patch the location of gfile
tf.gfile = tf.io.gfile

def convert_to_image(imgstring):
  imgdata = base64.b64decode(imgstring)
  filename = 'public/images/foot_detected.jpg'  # I assume you have a way of picking unique filenames
  with open(filename, 'wb') as f:
    f.write(imgdata)
  im_rgb = cv2.cvtColor(cv2.imread(filename), cv2.COLOR_BGR2RGB)
  return im_rgb

#print(tf.__version__)
#data = json.load(sys.stdin)
#image_convert_fromb64 = convert_to_image(str(data['image']))
#print(convert_to_image(str(data['image'])))
#exit()

# List of the strings that is used to add correct label for each box.
PATH_TO_LABELS = 'routes/object_detection/images/labelmap.pbtxt'
#PATH_TO_LABELS = 'd:/fitfoot/app_back/routes/object_detection/images/labelmap.pbtxt'
category_index = label_map_util.create_category_index_from_labelmap(PATH_TO_LABELS, use_display_name=True)

# If you want to test the code with your images, just add path to the images to the TEST_IMAGE_PATHS.
#PATH_TO_TEST_IMAGES_DIR = pathlib.Path('d:/fitfoot/app_back/routes/object_detection/test_images') #1
#TEST_IMAGE_PATHS = sorted(list(PATH_TO_TEST_IMAGES_DIR.glob("*.jpg"))) #2

#model_name = 'ssd_mobilenet_v1_coco_2017_11_17'
#detection_model = load_model(model_name)
#detection_model = tf.saved_model.load('d:/fitfoot/app_back/routes/object_detection/inference_graph/saved_model')
detection_model = tf.saved_model.load('routes/object_detection/inference_graph/saved_model')

def load_model(model_name):
  base_url = 'http://download.tensorflow.org/Models/object_detection/'
  model_file = model_name + '.tar.gz'
  model_dir = tf.keras.utils.get_file(
    fname=model_name, 
    origin=base_url + model_file,
    untar=True)

  model_dir = pathlib.Path(model_dir)/"saved_model"

  model = tf.saved_model.load(str(model_dir))

  return model

def run_inference_for_single_image(model, image):
  image = np.asarray(image)
  # The input needs to be a tensor, convert it using `tf.convert_to_tensor`.
  input_tensor = tf.convert_to_tensor(image)
  # The model expects a batch of images, so add an axis with `tf.newaxis`.
  input_tensor = input_tensor[tf.newaxis,...]

  # Run inference
  model_fn = model.signatures['serving_default']
  output_dict = model_fn(input_tensor)

  # All outputs are batches tensors.
  # Convert to numpy arrays, and take index [0] to remove the batch dimension.
  # We're only interested in the first num_detections.
  num_detections = int(output_dict.pop('num_detections'))
  output_dict = {key:value[0, :num_detections].numpy() 
                 for key,value in output_dict.items()}
  
  output_dict['num_detections'] = num_detections

  # detection_classes should be ints.
  output_dict['detection_classes'] = output_dict['detection_classes'].astype(np.int64)
  
  # Handle models with masks:
  if 'detection_masks' in output_dict:
    # Reframe the the bbox mask to the image size.
    detection_masks_reframed = utils_ops.reframe_box_masks_to_image_masks(
              output_dict['detection_masks'], output_dict['detection_boxes'],
               image.shape[0], image.shape[1])      
    detection_masks_reframed = tf.cast(detection_masks_reframed > 0.5,
                                       tf.uint8)
    output_dict['detection_masks_reframed'] = detection_masks_reframed.numpy()
    
  return output_dict


def crop_objects(image, image_np, output_dict,i):
#fahd
  global ymin, ymax, xmin, xmax
  #width, height = image.size #Image.open(image_path).size
  #width, height = image_np.shape
  height, width, _ = image_np.shape
  #Coordinates of detected objects
  ymin = int(output_dict['detection_boxes'][0][0]*height)
  xmin = int(output_dict['detection_boxes'][0][1]*width)
  ymax = int(output_dict['detection_boxes'][0][2]*height)
  xmax = int(output_dict['detection_boxes'][0][3]*width)

  #display(Image.fromarray(image_np[ymin:ymax, xmin:xmax])) #RGB

  img_to_save = cv2.cvtColor(image_np[ymin:ymax, xmin:xmax],cv2.COLOR_BGR2RGB)

  crop_img = cv2.cvtColor(image_np[ymin:ymax, xmin:xmax],cv2.COLOR_RGB2HSV) 
  #display(Image.fromarray(crop_img)) #BGR
    
  crop_img_HSV = cv2.cvtColor(image_np[ymin:ymax, xmin:xmax],cv2.COLOR_RGB2HSV)
    
  lower_red = np.array([0, 125, 125])
  upper_red = np.array([10, 255, 255])
    
  #lower_white = np.array([0,0,255])
  #upper_white = np.array([0,0,255])
    
  #lower_black = np.array([0,0,0])
  #upper_black = np.array([250,255,30])

  #lower_yellow = np.array([25,150,50])
  #upper_yellow = np.array([35,255,255])

  mask = cv2.inRange(crop_img_HSV,lower_red,upper_red)
  res = cv2.bitwise_and(crop_img,crop_img,mask=mask)
  
  #display(Image.fromarray(mask))
  
  #print((ymax-ymin) * (xmax-xmin))
  total = (ymax-ymin) * (xmax-xmin)
  black = 0
  for pixel in Image.fromarray(res).getdata():
        if pixel == (0, 0, 0):
            black += 1
        
  global p_rougeur
  p_rougeur = float("{:.2f}".format((1 - (black/total))*100))
  #print(str(p_rougeur) + '%')

  #display(Image.fromarray(cv2.cvtColor(res,cv2.COLOR_HSV2RGB)))
  #plt.figure(figsize=(20,8))
  #plt.imshow(mask)

  #display(Image.fromarray(np.array(crop_img_HSV)))
  #print(crop_img)
    
  #if output_dict['detection_scores'][0] > 0.5:
        #crop_img.fill(0)
        
  #Save cropped object into image
  #cv2.imwrite('object_detection/cropped_detection/test'+str(i)+'.jpg', img_to_save)
  
  return ymin, ymax, xmin, xmax




def show_inference(model, image_path):
  # the array based representation of the image will be used later in order to prepare the
  # result image with boxes and labels on it.
    
  image = image_path
  #image = Image.open(image_path)
  image_np = np.array(image)

  #display(Image.fromarray(image_np))
  #image_np = image_path
  # Actual detection.
  output_dict = run_inference_for_single_image(model, image_np)
  # Visualization of the results of a detection.
  #print(output_dict['detection_scores'][0])
  vis_util.visualize_boxes_and_labels_on_image_array(
      image_np,
      output_dict['detection_boxes'],
      output_dict['detection_classes'],
      output_dict['detection_scores'],
      category_index,
      min_score_thresh=0.5,
      instance_masks=output_dict.get('detection_masks_reframed', None),
      use_normalized_coordinates=True,
      line_thickness=3)
    
  if output_dict['detection_scores'][0] < 0.5:
    return

  global detection
  detection = 'true'
  #fahd *crop*
  #load_image_into_numpy_array(Image.open(image_path)) arg 2
  #Image.open(image_path) arg 1
  crop_objects(image,image_np,output_dict,0)
  
  pil_im = Image.fromarray(image_np)
  b = io.BytesIO()
  pil_im.save(b, 'jpeg')
  im_bytes = b.getvalue()
  encoded_string = base64.b64encode(im_bytes)
  global image1
  image1 = encoded_string
  image1 = image1.decode("utf-8")
  #display(Image.fromarray(image_np))

#print('loaded')