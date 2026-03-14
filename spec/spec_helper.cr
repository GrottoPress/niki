require "spec"
require "webmock"
require "../src/niki"

Spec.before_each do
  WebMock.reset
end
