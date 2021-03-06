context("rbind.mids")

imp1 <- mice(nhanes[1:13, ], m = 2, maxit = 1, print = FALSE)
imp2 <- mice(nhanes[14:25, ], m = 2, maxit = 1, print = FALSE)
imp3 <- mice(nhanes2, m = 2, maxit = 1, print = FALSE)
imp4 <- mice(nhanes2, m = 1, maxit = 1, print = FALSE)
imp5 <- mice(nhanes[1:13, ], m = 2, maxit = 2, print = FALSE)

mylist <- list(age = NA, bmi = NA, hyp = NA, chl = NA)
nhalf <- nhanes[13:25, ]

test_that("Throws warning", {
  expect_warning(rbind(imp1, imp2))
})

test_that("Stops on impossible task", {
  expect_error(rbind(imp1, imp3), "Datasets have different factor variables")
  expect_error(rbind(imp3, imp4), "Number of imputations differ")
})

test_that("Produces longer imputed data", {
  expect_equal(nrow(complete(rbind(imp1, imp5))), 26)
  expect_equal(nrow(complete(rbind(imp1, mylist))), 14)
  expect_equal(sum(is.na(complete(mice:::rbind.mids(imp1, nhalf)))), 15)
})

# issue #59
set.seed <- 818
x <- rnorm(10)
D <- data.frame(x=x, y=2*x+rnorm(10))
D[c(2:4, 7), 1] <- NA
D_mids <- mice(D[1:5,], print = FALSE)
D_rbind <- mice:::rbind.mids(D_mids, D[6:10,])
cmp <- complete(D_rbind, 1)
test_that("Solves issue #59, rbind", expect_identical(cmp[6:10, ], D[6:10, ]))


