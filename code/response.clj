(use 'overtone.live)

(defn play_freq [n]
	(demo (sin-osc n)))

(defn response [n] 
	(cond (< (* n 100) 18000) 
		(future 
			(Thread/sleep 1000) 
			(println (* n 100)) 
			(play_freq (* n 100)) 
			(response (+ n 1))) 
		:else (println 'end') ))

(response 140)

(defn low_response [n] 
	(cond (> (* n 10) 0) 
		(future 
			(Thread/sleep 1000) 
			(println (* n 10)) 
			(play_freq (* n 10)) 
			(low_response (- n 1))) 
		:else (println 'end') ))


(low_response 10)