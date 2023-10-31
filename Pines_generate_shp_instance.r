
# this code generated the instance + buffer to have the instance segmentation + add the segment that have no intersection
# with the intance, which are the small tree

setwd("G:/Chapter1/Pines/")


library(sf)
#listing the files
list_shp_instance=list.files("./RESULT/MASK_crownI/",pattern=".shp",full.names = TRUE)
list_shp_mask=list.files("./RESULT/MASK_crownS/",pattern=".shp",full.names = TRUE)

#removing those already done, if any
list_shp_instance_already_done=list.files("./RESULT/MASK_instance/",pattern=".shp",full.names = TRUE)

already_done=which(basename(list_shp_mask) %in% basename(list_shp_instance_already_done))

if (length(already_done)!=0){
  list_shp_instance=list_shp_instance[-already_done]
  list_shp_mask=list_shp_mask[-already_done]
}


#combine the shape buffer and segment to make full shape instance
for (i in 1:length(list_shp_instance)){
  poly_sf=st_read(list_shp_instance[i])
  poly_segment=st_read(list_shp_mask[i])
  poly_instance=st_buffer(poly_sf, dist = 0.6, endCapStyle="SQUARE",joinStyle ='MITRE', mitreLimit = 5)
  segment_to_keep=st_intersects(poly_segment,poly_instance)
  zero_test=unlist(lapply(segment_to_keep,sum))
  poly_segment_to_keep=poly_segment[unlist(lapply(segment_to_keep,sum))==0,]
  poly_instance=rbind(poly_instance,poly_segment_to_keep)
  #poly_instance=st_buffer(poly_instance, dist = -0.0000001)
  st_write(poly_instance,sub("MASK_crownI","MASK_instance",list_shp_instance[i]))
  rm(poly_sf)
  rm(poly_instance)
}

 