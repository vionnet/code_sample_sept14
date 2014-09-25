package recfun
import common._

object Main {
  def main(args: Array[String]) {
    println("Pascal's Triangle")
    for (row <- 0 to 10) {
      for (col <- 0 to row)
        print(pascal(col, row) + " ")
      println()
    }
  }

  /**
   * Exercise 1
   */
  def pascal(c: Int, r: Int): Int = {
    if (c==0) 1
    else if (c==r) 1
    else pascal(c-1,r-1) + pascal(c, r-1)
  }

  /**
   * Exercise 2
   */
  def balance(chars: List[Char]): Boolean = {
    def checkBalance(leftParen: Int, rightParen: Int, chars: List[Char]): Boolean = {
        if (leftParen < rightParen) false
        else if (chars.isEmpty && leftParen != rightParen) false
        else if (chars.isEmpty && leftParen == rightParen) true
        else {
          if (chars.head == '(') checkBalance(leftParen+1, rightParen, chars.tail)
          else if (chars.head == ')') checkBalance(leftParen, rightParen+1, chars.tail)
          else checkBalance(leftParen, rightParen, chars.tail)
        }
            
    }
    
    if (chars.isEmpty) true
    else checkBalance(0, 0, chars)        
  }

  /**
   * Exercise 3
   */
  def countChange(money: Int, coins: List[Int]): Int = {
    if (money == 0) 1
    else if (money < 0) 0
    else if (coins.isEmpty) 0
    else countChange(money-coins.head, coins) + countChange(money, coins.tail)
  }
}
