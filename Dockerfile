FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04@sha256:75064155a974b9358330665739771b65456d27be6802aa30ae368ba66f251189
#Install requirements and download files
RUN apt-get update && apt-get install -y git wget imagemagick && \
    git clone https://gitlab.com/Shinobi-Systems/Shinobi.git src/ && \
    mkdir src/plugins/yolo/models && wget -O src/plugins/yolo/models/yolov3.weights https://pjreddie.com/media/files/yolov3-tiny.weigh>    mkdir src/plugins/yolo/models/cfg && wget -O src/plugins/yolo/models/cfg/coco.data https://raw.githubusercontent.com/pjreddie/dark>    wget -O src/plugins/yolo/models/cfg/yolov3.cfg https://raw.githubusercontent.com/pjreddie/darknet/master/cfg/yolov3-tiny.cfg && \
    mkdir src/plugins/yolo/models/data && wget -O src/plugins/yolo/models/data/coco.names https://raw.githubusercontent.com/pjreddie/d>    cp src/plugins/yolo/conf.sample.json src/plugins/yolo/conf.json

#Install Node.js
RUN wget https://deb.nodesource.com/setup_12.x && chmod +x setup_12.x && ./setup_12.x && apt-get install nodejs -y && rm setup_12.x

#Install Node packages
WORKDIR /src/plugins/yolo
RUN npm install -g pm2 && \
    npm install node-gyp -g --unsafe-perm && \
    npm install --unsafe-perm && \
    npm install node-yolo-shinobi --unsafe-perm && \
    npm audit fix --force

WORKDIR /src
RUN npm install --unsafe-perm \
    && npm audit fix --force

CMD [ "pm2-runtime", "/src/plugins/yolo/shinobi-yolo.js" ]
