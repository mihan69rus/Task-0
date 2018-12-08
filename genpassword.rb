#Program can start with arguments:	length <length of password>
#					number <number of passwords>

ODDSVOWEL = 40
ODDSCONS = 40
ODDSNUM = 20
ODDSSPEC = 10
ODDSALL = ODDSVOWEL + ODDSCONS + ODDSNUM + ODDSSPEC
STARTNUMBER = 10
STARTLENGTH = 8

class GetNumber
  def get
    rand(10)
  end
end
 
class GetConsonant
  def initialize
    @consonant = %w[b c d f g h j k l m n p q r s t v w x z]
  end

  def get
    @consonant[rand(@consonant.size)]
  end
end

class GetVowel 
  def initialize
    @vowel = %w[a e i o u y]
  end

  def get
    @vowel[rand(@vowel.size)]
  end
end

class GetSpecial 
  def initialize
    @special = %w[@ $ ? !]
  end

  def get
    @special[rand(@special.size)]
  end
end

class GetSym
  def initialize(n)
    @work_vowel = ODDSVOWEL 
    @work_consonant = ODDSCONS 
    @work_special = ODDSSPEC 
    @work_number = ODDSNUM * n 
    @odds = Array.new(ODDSALL)
    state(ODDSVOWEL,ODDSCONS,ODDSNUM,ODDSSPEC)
  end

  def state(vowel, consonant, number, special)
    @gen_vowel = GetVowel.new
    @gen_consonant = GetConsonant.new
    @gen_number = GetNumber.new
    @gen_special = GetSpecial.new
    0.upto(vowel) { |x| @odds[x] = @gen_vowel  }
    letter = vowel + consonant
    (vowel+1).upto(letter) { |x| @odds[x] = @gen_consonant }
    num_and_letter = letter+number
    (letter+1).upto(num_and_letter) { |x| @odds[x] = @gen_number }
    @all = num_and_letter+special
    (num_and_letter+1).upto(@all) { |x| @odds[x] = @gen_special }
  end

  def get_sym
    random_elem = @odds[rand(@all)]
    if random_elem.class == GetConsonant && @work_vowel == @work_consonant
      @work_consonant = @work_consonant/2
      @work_vowel = @work_vowel + @work_consonant
    elsif random_elem.class == GetVowel
      @work_consonant = (@work_consonant + @work_vowel)/2
      @work_vowel = @work_consonant
    elsif random_elem.class == GetSpecial
      @work_special = 0
    else
      @work_number = @work_number - ODDSNUM/2
    end
    sym = random_elem.get
    state(@work_vowel, @work_consonant, @work_number, @work_special)
    if sym.class == String && rand(3) == 0
        sym.upcase
    else
        sym
    end
  end
end

class GetPass
  def get_pass(length)
    s = String.new
    generator = GetSym.new(length/STARTLENGTH)
    length.times { s = s + generator.get_sym.to_s }
    s
  end
end

number = STARTNUMBER
length = STARTLENGTH
if ARGV.size == 0 || ARGV.size == 2 || ARGV.size == 4
  if ARGV.size > 0
    if ARGV[0] == "length"
      length = ARGV[1].to_i
    elsif ARGV[0] == "number"
      number = ARGV[1].to_i 
    else
      puts "Bad arguments"
      exit
    end
    if ARGV.size == 4
      if ARGV[0] == ARGV[2]
        puts "Bad arguments"
        exit
      end
      if ARGV[2] == "length"
        length = ARGV[3].to_i
      elsif ARGV[2] == "number"
        number = ARGV[3].to_i 
      else 
        puts "Bad arguments"
        exit
      end
    end
  end
else
  puts "Bad number of arguments"
  exit
end
password = GetPass.new
number.times { puts password.get_pass(length) }
