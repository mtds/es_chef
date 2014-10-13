# === NAMING
#
default.elasticsearch[:cluster][:name] = 'es.hpc.gsi'
default.elasticsearch[:node][:name]    = node.name

# === NODE TYPE
#
default.elasticsearch[:node][:master]  = true
default.elasticsearch[:node][:data]    = true
default.elasticsearch[:node][:max_local_storage_nodes] = 1

# === USER/GROUP
#
default.elasticsearch[:user] = "elasticsearch"
default.elasticsearch[:group] = "elasticsearch"

# === MEMORY
#
# Maximum amount of memory to use is automatically computed 
# as one half of total available memory on the machine.
#
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch[:allocated_memory] = allocated_memory

# === GARBAGE COLLECTION SETTINGS
#
default.elasticsearch[:gc_settings] =<<-CONFIG
  -XX:+UseParNewGC
  -XX:+UseConcMarkSweepGC
  -XX:CMSInitiatingOccupancyFraction=75
  -XX:+UseCMSInitiatingOccupancyOnly
  -XX:+HeapDumpOnOutOfMemoryError
CONFIG

# === LIMITS
#
# By default, the `mlockall` is set to true: on weak machines 
# and Vagrant boxes, you may want to disable it.
#
default.elasticsearch[:bootstrap][:mlockall] = ( node.memory.total.to_i >= 1048576 ? true : false )
default.elasticsearch[:limits][:memlock] = 'unlimited'
default.elasticsearch[:limits][:nofile]  = '64000'

# === INDEX SETTINGS
#
default.elasticsearch[:index][:mapper][:dynamic]   = true
default.elasticsearch[:index][:store][:type] = 'mmapfs' # Used on Linux 64 bit JVM.
default.elasticsearch[:action][:auto_create_index] = true
default.elasticsearch[:action][:disable_delete_all_indices] = true

# === THREAD POOL
#
default.elasticsearch[:threadpool][:bulk][:type] = 'fixed' 
default.elasticsearch[:threadpool][:bulk][:size] = "#{(node.cpu.total.to_i)}"
default.elasticsearch[:threadpool][:bulk][:queue_size] = 50

default.elasticsearch[:threadpool][:index][:type] = 'fixed' 
default.elasticsearch[:threadpool][:index][:size] = "#{(node.cpu.total.to_i)}"
default.elasticsearch[:threadpool][:index][:queue_size] = 200

default.elasticsearch[:threadpool][:search][:type] = 'fixed' 
default.elasticsearch[:threadpool][:search][:size] = "#{(node.cpu.total.to_i * 3)}"
default.elasticsearch[:threadpool][:search][:queue_size] = 1000

# === DISCOVERY SETTINGS
#
default.elasticsearch[:discovery][:zen][:ping][:multicast][:enabled] = false
default.elasticsearch[:discovery][:zen][:minimum_master_nodes] = 1

# === GATEWAY SETTINGS
#
default.elasticsearch[:gateway][:type] = 'local'
default.elasticsearch[:gateway][:expected_nodes] = 1

# === THREAD STACK
#
# The stack memory is allocated per thread. In Elasticsearch, the size 
# of the stack per thread had to be increased from 128k to 256k, because 
# Java 7 stack frames are larger than in Java 6. 
default.elasticsearch[:thread_stack_size] = "256k"

# === PORT
#
default.elasticsearch[:http][:port] = 9200

# === PLUGINS
#
default.elasticsearch[:plugins_enable] = false
default.elasticsearch[:plugins]= Hash.new
