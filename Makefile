BRIDGE := ixp-net

.PHONY: deploy
deploy: start
	@echo "Deployment completed."

.PHONY: start
start:
	# Create the bridge if it doesn't exist
	@if ! brctl show | grep -q $(BRIDGE); then \
		brctl addbr $(BRIDGE); \
		ip link set dev $(BRIDGE) up; \
		echo "Bridge $(BRIDGE) created and brought up."; \
	else \
		echo "Bridge $(BRIDGE) already exists."; \
	fi
	containerlab deploy

.PHONY: destroy
destroy: stop
	@echo "Destruction completed."

.PHONY: stop
stop:
	# bring down containerlab
	containerlab destroy
	# Bring the bridge interface down
	ip link set dev $(BRIDGE) down
	# Delete the bridge
	brctl delbr $(BRIDGE)
	@echo "Bridge $(BRIDGE) brought down and deleted."

