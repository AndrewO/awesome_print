# Copyright (c) 2010-2011 Michael Dvorkin
#
# Awesome Print is freely distributable under the terms of MIT license.
# See LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
class Class #:nodoc:
  # Remaining public/private etc. '_methods' are handled in core_ext/object.rb.
  %w(instance_methods private_instance_methods protected_instance_methods public_instance_methods).each do |name|
    alias :"original_#{name}" :"#{name}"

    define_method name do |*args|
      methods = self.__send__(:"original_#{name}", *args)
      methods.instance_variable_set('@__awesome_methods__', self) # Evil?!
      methods.sort!
    end
  end
end
