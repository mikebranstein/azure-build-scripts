using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ApiDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private static readonly Account[] _accounts = new Account[] {
                new Account() { Id = 1, Name = "Savings", Balance = 52345.43 },
                new Account() { Id = 2, Name = "Checking", Balance = 6548.22 },
                new Account() { Id = 3, Name = "Brokerage", Balance = 1245533.98 },
                new Account() { Id = 4, Name = "Business", Balance = 544294.76 },
                new Account() { Id = 5, Name = "Credit Line", Balance = 300000.00 }
            };

        // GET: api/Account
        [HttpGet]
        public IEnumerable<Account> Get()
        {
            return _accounts;
        }

        // GET: api/Account/5
        [HttpGet("{id}", Name = "Get")]
        public Account Get(int id)
        {
            return _accounts.Where(x => x.Id == id).FirstOrDefault();
        }

        // PUT: api/Account/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string accountName)
        {
            if (_accounts.Count(x => x.Id == id) == 0)
                _accounts.Append(new Account() { Id = id, Name = accountName, Balance = 0.0 });
        }
    }

    public class Account
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public double Balance { get; set; }

    }
}
