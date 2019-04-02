DOCKER=docker
DOCKER_OPT=--network=host
IMG=rimg
CMD=bash
USER=kkholst
REPO=rdbase
TAG=$(IMG)

build:
	@$(DOCKER) build $(DOCKER_OPT) -f Dockerfile.$(IMG) -t $(TAG) .

run:
	@$(DOCKER) run $(DOCKER_OPT) -ti -t $(IMG) bash

xrun:
	xhost +SI:localuser:$$(id -un) &> /dev/null && \
	   $(DOCKER) run $(DOCKER_OPT) -it --rm -e DISPLAY=$(DISPLAY) \
	   --privileged -v /data:/data \
           -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	   --user $$(id -u):0 \
           --ipc=host \
           $(IMG) $(CMD)
#	    --user $$(id -u):$$(id -g) \

dclean:
	@$(DOCKER) ps -a -q -f status=exited | xargs $(DOCKER) rm -v

iclean:
	-@$(DOCKER) rmi $(docker images --filter "dangling=true" -q --no-trunc)
	@$(DOCKER) images -a | grep "^<none>" | awk '{print $$3}' | xargs $(DOCKER) rmi

dlogin:
	@$(DOCKER) login --username=$(USER) --password=$(PWD)

dpush:
	$(DOCKER) build $(DOCKER_OPT) -t $(USER)/$(REPO):$(TAG) . -f Dockerfile.$(IMG)
	$(DOCKER) push $(USER)/$(REPO):$(TAG)
