.FORCE:
chapter%: .FORCE
	cd $@ && vagrant up

.PHONY: clean
clean:
	for chapter in chapter* ; do echo Destroying $$chapter ; (cd $$chapter ; vagrant destroy -f) ; done
