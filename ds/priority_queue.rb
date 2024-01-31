class PriorityQueue
  def initialize
    @heap = []
  end

  def push(item, priority)
    @heap << [priority, item]
    bubble_up(@heap.size - 1)
  end

  def pop
    return nil if @heap.empty?

    highest_priority_item = @heap[0][1]
    @heap[0] = @heap[@heap.size - 1]
    @heap.pop
    bubble_down(0)
    highest_priority_item
  end

  def empty?
    @heap.empty?
  end

  private

  def bubble_up(index)
    parent_index = (index - 1) / 2
    return if index == 0 || @heap[parent_index][0] <= @heap[index][0]

    @heap[parent_index], @heap[index] = @heap[index], @heap[parent_index]
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (2 * index) + 1
    return if child_index >= @heap.size

    left_child = @heap[child_index]
    right_child = @heap[child_index + 1]
    swap_index = child_index

    swap_index += 1 if right_child && right_child[0] < left_child[0]

    return unless @heap[swap_index][0] < @heap[index][0]

    @heap[swap_index], @heap[index] = @heap[index], @heap[swap_index]
    bubble_down(swap_index)
  end
end
