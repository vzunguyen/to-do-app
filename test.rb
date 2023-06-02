class ToDo
    attr_accessor :description, :time

    def initialize(description, time)
        @description = description
        @time = time
    end
end

def read_todo(a_file)
    todo_description = a_file.gets()
    todo_time = a_file.gets.to_i
    @todo = ToDo.new(todo_description, todo_time)
    return @todo
end


def read_todo_list()
    @todo_file = 'todo_list.txt'
    todo_file = File.new(@todo_file, "r")

    @todo_list = Array.new()
    count = todo_file.gets.to_i
    puts count.to_s
    i = 0
    while i < count
        todo = read_todo(todo_file)
        @todo_list << todo
        i += 1
    end
    
    return @todo_list
    todo_file.close

end

@todo_list = read_todo_list

i = 0
while i < @todo_list.length
    print @todo_list[i].description
    print "\n"
    i += 1
end