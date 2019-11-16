ifneq ($(MODULE),)

# Use this as a module for testing REQUIRE

$_variable1 = v1
$_variable2 = v2

else

# Use this to define test cases

MODULE = $(strip $(firstword $(MAKEFILE_LIST)))

include require.mk

define test_with_module_prefix

$(call REQUIRE,$(MODULE),bob)
ifneq ($(bob.variable1),v1)
$(error FAIL)
endif

endef

define test_without_module_prefix

$(call REQUIRE,$(MODULE))
# TODO: fix REQUIRE so no prefix is functional
ifneq ($(.variable1),v1)
$(error FAIL)
endif

endef

TEST_CASES = $(filter test_%,$(.VARIABLES))

ifneq ($(TEST_CASE),)

$(eval $(value $(TEST_CASE)))

.PHONY: test
test:
	@echo OK

else

.PHONY: test $(TEST_CASES)
test: $(TEST_CASES)
$(TEST_CASES):
	@echo $@
	@make -s -f $(MODULE) TEST_CASE=$@

endif

endif