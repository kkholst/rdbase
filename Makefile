DOCKER=docker
DOCKER_OPT=--network=host
IMG=rimg
CMD=bash

build:
	@$(DOCKER) build $(DOCKER_OPT) -f Dockerfile.$(IMG) -t $(IMG) .

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
