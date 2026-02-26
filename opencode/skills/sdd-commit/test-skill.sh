#!/bin/bash
# Test script for sdd-commit skill
# Usage: ./test-sdd-commit.sh [test-case]

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
  local test_name="$1"
  local test_cmd="$2"
  
  TESTS_RUN=$((TESTS_RUN + 1))
  echo -e "${YELLOW}Test ${TESTS_RUN}: ${test_name}${NC}"
  
  if eval "$test_cmd"; then
    echo -e "${GREEN}✓ PASSED${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  else
    echo -e "${RED}✗ FAILED${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
  fi
  echo ""
}

echo "======================================"
echo "Testing sdd-commit Skill"
echo "======================================"
echo ""

# Test 1: Check skill file exists
run_test "Skill file exists" \
  "test -f ~/.opencode/skills/sdd-commit/SKILL.md"

# Test 2: Check skill has proper header
run_test "Skill has valid YAML header" \
  "head -10 ~/.opencode/skills/sdd-commit/SKILL.md | grep -q 'name: sdd-commit'"

# Test 3: Check Purpose section exists
run_test "Purpose section exists" \
  "grep -q '^## Purpose' ~/.opencode/skills/sdd-commit/SKILL.md"

# Test 4: Check Execution Contract section
run_test "Execution Contract section exists" \
  "grep -q '^## Execution and Persistence Contract' ~/.opencode/skills/sdd-commit/SKILL.md"

# Test 5: Check Scenarios section with test cases
run_test "Scenarios section with test cases" \
  "grep -q '^## Scenarios' ~/.opencode/skills/sdd-commit/SKILL.md"

# Test 6: Check all commit types are documented
run_test "All commit types documented" \
  "test \$(grep -E 'feat|fix|docs|style|refactor|perf|test|chore|ci|revert' ~/.opencode/skills/sdd-commit/SKILL.md | wc -l) -ge 10"

# Test 7: Check breaking change handling
run_test "Breaking change handling documented" \
  "grep -q 'breaking' ~/.opencode/skills/sdd-commit/SKILL.md"

# Test 8: Check original command is deprecated
run_test "Original commit command deprecated" \
  "grep -q 'DEPRECATED' ~/dotfiles/opencode/commands/commit.md"

# Test 9: Check skill is linked from dotfiles
run_test "Skill linked from dotfiles" \
  "test -f ~/dotfiles/opencode/skills/sdd-commit/SKILL.md"

# Test 10: Check README mentions new skill
run_test "README mentions sdd-commit skill" \
  "grep -q 'sdd-commit' ~/dotfiles/README.md"

echo "======================================"
echo "Test Summary"
echo "======================================"
echo "Total tests: ${TESTS_RUN}"
echo -e "${GREEN}Passed: ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed: ${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
else
  echo -e "${RED}Some tests failed!${NC}"
  exit 1
fi
