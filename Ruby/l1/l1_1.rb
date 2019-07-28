require 'test/unit'
#Ta funkcja słownie wypisuje liczbę
def slownie(n)
  argument = n
  hash_num = {
  0 => ["jeden","dwa","trzy","cztery","pięć","sześć","siedem","osiem","dziewięć"],
  1 => ["dziesięć","dwadzieścia","trzydzieści","czterdzieści","pięćdziesiąt","sześćdziesiąt","siedemdziesiąt",
    "osiemdziesiąt","dziewięćdziesiąt"],
  2 => ["sto","dwieście","trzysta","czterysta", "pięćset", "sześćset", "siedemset",
  "osiemset","dziewięćset"],
  3 => ["tysiąc","dwa tysiące", "trzy tysiące", "cztery tysiące", "pięć tysięcy", "sześć tysięcy", "siedem tysięcy",
  "osiem tysięcy", "dziewięć tysięcy"],
  4 => ["jedenaście","dwanaście","trzynaście","czternaście","piętnaście","szesnaście","siedemnaście",
    "osiemnaście","dziewiętnaście"]
  }
  if n == 0
    return "zero"
  end
  n = n.to_s.reverse
  num_literal_result = ""
  if argument < 20 && argument > 10
    return hash_num[4][Integer(n[0])-1]
  end
  for i in 0..(Integer(n.length)-1) do
    if n[i] != "0"
      num_literal_result = hash_num[i][Integer(n[i])-1] + " " + num_literal_result
    end
  end
  if n[1] == "1" && n[0] != "0"
    return num_literal_result.split(' ')[0...-2].join(' ') + " " + hash_num[4][Integer(n[0])-1]
  end
  return num_literal_result
end

class TestSlownie < Test::Unit::TestCase
 #Ta funkcja to testy
  def test_slownie
    assert_equal("zero",  slownie(0))
    assert_equal("sześć ",  slownie(6))
    assert_equal("dziesięć ",  slownie(10))
    assert_equal("jedenaście",  slownie(11))
    assert_equal("piętnaście",  slownie(15))
    assert_equal("trzydzieści pięć ",  slownie(35))
    assert_equal("pięćdziesiąt ",  slownie(50))
    assert_equal("siedemdziesiąt cztery ", slownie(74))
    assert_equal("dziewięćdziesiąt ", slownie(90))
    assert_equal("sto jeden ", slownie(101))
    assert_equal("sto piętnaście", slownie(115))
    assert_equal("sto dwadzieścia ", slownie(120))
    assert_equal("sto dziewięćdziesiąt dwa ", slownie(192))
    assert_equal("dziewięćset dziewięćdziesiąt dziewięć ", slownie(999))
    assert_equal("tysiąc ", slownie(1000))
    assert_equal("tysiąc szesnaście", slownie(1016))
    assert_equal("dwa tysiące dwa ", slownie(2002))
    assert_equal("dwa tysiące dziewiętnaście", slownie(2019))
    assert_equal("cztery tysiące cztery ", slownie(4004))
    assert_equal("pięć tysięcy sześćset cztery ", slownie(5604))
    assert_equal("siedem tysięcy dziewięćset osiemdziesiąt ", slownie(7980))
    assert_equal("dziewięć tysięcy dziewięćset dziewiętnaście", slownie(9919))
    assert_equal("dziewięć tysięcy dziewięćset dziewięćdziesiąt dziewięć ", slownie(9999))

  end
 
end
