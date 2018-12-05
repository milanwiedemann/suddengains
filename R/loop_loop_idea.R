get_pre_gain <- function(seq, col_idx)
{
  start_idx = max(1, col_idx - 3)
  return(seq[start_idx : (col_idx - 1)])
}


get_post_gain <- function(seq, col_idx)
{
  end_idx = min(length(seq), col_idx + 3)
  return(seq[(col_idx + 1) : end_idx])
}


lala <- function(data, id_name, start, jump_matrix) {


  pre_post_gain = list()
  for (line in 1:base::nrow(jump_matrix))
  {

    sample_id <- data[line, id_name]

    for (col in 1:(base::ncol(jump_matrix) - 1))
    {
      if (jump_matrix[line, col] == 1)
      {
        next_idx = length(pre_post_gain) + 1
        current_seq = list(data[start : (start + base:ncol(jump_matrix)), line])
        pre_gain = get_pre_gain(current_seq, col)
        post_gain = get_post_gain(current_seq, col)
        pre_post_gain[[next_idx]] = list(id = sample_id, jump = col, pre_gain = pre_gain, post_gain = post_gain)
      }
    }
  }





}
