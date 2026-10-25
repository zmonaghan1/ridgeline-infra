// Ridgeline lab: monthly cost budget with email alerts at $25, $50 and $75.
// Deploys at subscription scope, so it watches every resource group in the lab.
targetScope = 'subscription'

@description('Name of the budget, following the naming standard (budget-<workload>-<period>).')
param budgetName string = 'budget-ridgeline-monthly'

@description('Monthly budget in the billing currency (CAD for a Canadian account). The top alert fires here.')
param amount int = 75

@description('Who gets the alert emails.')
param contactEmails array

@description('Budgets must start on the first day of a month. Defaults to this month.')
param startDate string = '${utcNow('yyyy-MM')}-01'

resource budget 'Microsoft.Consumption/budgets@2023-05-01' = {
  name: budgetName
  properties: {
    category: 'Cost'
    amount: amount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    // Thresholds are percentages of the budget amount, not dollars.
    // With amount = 75: 33% fires at $24.75, 66% at $49.50, 100% at $75.
    notifications: {
      // First warning: about $25 spent. Check nothing was left running.
      actual25: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 33
        thresholdType: 'Actual'
        contactEmails: contactEmails
      }
      // Second warning: about $50 spent. Look at Cost analysis grouped by the phase tag.
      actual50: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 66
        thresholdType: 'Actual'
        contactEmails: contactEmails
      }
      // The line in the sand: $75 actually spent this month.
      actual75: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 100
        thresholdType: 'Actual'
        contactEmails: contactEmails
      }
      // Forecast: Azure predicts you'll pass $75 by month end. Usually the first to fire if something is left running.
      forecast75: {
        enabled: true
        operator: 'GreaterThanOrEqualTo'
        threshold: 100
        thresholdType: 'Forecasted'
        contactEmails: contactEmails
      }
    }
  }
}

output budgetId string = budget.id
