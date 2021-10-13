import load_model

data = load_model.json.load(load_model.sys.stdin)
image_convert_fromb64 = load_model.convert_to_image(str(data['image']))
load_model.show_inference(load_model.detection_model,image_convert_fromb64)
#print('done.')
resp = {
  "Tf2v":load_model.tf.__version__,
  "Detection":load_model.detection,
  "RednessPerc":load_model.p_rougeur,
  "Image1":load_model.image1,
  "Image2":load_model.image2
}
print(load_model.json.dumps(resp))
#sys.stdout.flush()