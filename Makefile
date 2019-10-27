DOCKER=docker
DOCKER_OPT=--network=host
IMG=test
CMD=bash
USER=kkholst
REPO=rdbase
TAG=$(IMG)
PWD:=`pwd`
CONTAINER_EXISTS:=$(shell $(DOCKER) ps | awk '{print $$NF}' | grep -w run_$(IMG))

default:
	$(MAKE) build IMG=base
	$(MAKE) login
	$(MAKE) dpush

.PHONY: build
build:
	@$(DOCKER) build --rm $(DOCKER_OPT) -f Dockerfile.$(IMG) -t $(TAG) .


.PHONY: update
update:
	$(DOCKER) images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>" | sort | uniq | xargs -L1 docker pull

.PHONY: run
run:
	@if [ -z "${CONTAINER_EXISTS}" ]; then \
	$(DOCKER) run $(DOCKER_OPT) -v $(PWD)/data:/data --rm --privileged --name run_$(IMG) -ti -t $(IMG) $(CMD); \
	else \
	$(DOCKER) exec -ti run_$(IMG) $(CMD); \
	fi;

.PHONY: apkinfo
apkinfo: 
	$(DOCKER) run $(DOCKER_OPT) -ti -t $(IMG) apk info | xargs -n1 -I{} apk info -s {} | xargs -n4 | awk '{print $4,$1}' | sort -n

.PHONY: apkinfo
xrun:
	xhost +SI:localuser:$$(id -un) &> /dev/null && \
	   $(DOCKER) run $(DOCKER_OPT) -it --rm -e DISPLAY=$(DISPLAY) \
	   --privileged -v /data:/data \
           -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	   --user $$(id -u):0 \
           --ipc=host \
           $(IMG) $(CMD)
#	    --user $$(id -u):$$(id -g) \

.PHONY: clean
clean: dclean iclean
	$(DOCKER) images

.PHONY: dclean
dclean:
	-@$(DOCKER) ps -a -q -f status=exited | xargs $(DOCKER) rm -v

.PHONY: iclean
iclean:
	-@$(DOCKER) rmi $(docker images --filter "dangling=true" -q --no-trunc)
	-@$(DOCKER) images -a | grep "^<none>" | awk '{print $$3}' | xargs $(DOCKER) rmi

.PHONY: login
login:
	@$(DOCKER) login --username=$(USER)

.PHONY: dlogin
dlogin:
	@$(DOCKER) login --username=$(USER) --password=$(PWD)

.PHONY: dpush
dpush:
	$(DOCKER) build --rm $(DOCKER_OPT) -t $(USER)/$(REPO):$(TAG) . -f Dockerfile.$(IMG)
	$(DOCKER) push $(USER)/$(REPO):$(TAG)


