




library(ggmap)
library(maptools)
library(maps)


#mapWorld <- borders("world", colour="gray50", fill="white")

mapWorld <- map_data("world")

mp1 <- ggplot(mapWorld, aes(x=long, y=lat, group=group))+
  geom_polygon(fill="white", color="black") +
  coord_map(xlim=c(-180,180), ylim=c(-60, 90))

mp1
# 圆柱型
mp2 <- mp1 + coord_map("cylindrical",xlim=c(-180,180), ylim=c(-60, 90))

mp2

mp2 <- mp1 + coord_map("mercator",xlim=c(-180,180), ylim=c(-60, 90))


mp2

# 正弦的
mp2 <- mp1 + coord_map("sinusoidal", xlim=c(-180,180), ylim=c(-60, 90))

mp2

mp2 <- mp1 + coord_map("gnomonic", xlim=c(-180,180), ylim=c(-60, 90))

mp2


mp2 <- mp1 + coord_map("rectangular", parameters = 0, xlim=c(-180,180), ylim=c(-60, 90))

mp2


mp2 <- mp1 + coord_map("cylequalarea", parameters = 0, xlim=c(-180,180), ylim=c(-60, 90))

mp2



##############################################










