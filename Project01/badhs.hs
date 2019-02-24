occurs :: Eq a => a -> [a] -> Bool 
occurs x l = x `elem` l
